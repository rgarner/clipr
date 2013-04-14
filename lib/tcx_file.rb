require 'nokogiri'
require 'time'

##
# A Garmin TCX file
class TCXFile
  def initialize(tcx_str)
    @doc = Nokogiri::XML(tcx_str)
    @doc.remove_namespaces!
  end

  ##
  # Lap nodes
  def laps
    @laps ||= @doc.xpath('//Activity/Lap')
  end

  ##
  # Trackpoint nodes
  def trackpoints
    @trackpoints ||= @doc.xpath('//Track[1]/Trackpoint')
  end

  def reported_avg_speed
    @doc.xpath('//Activity/Lap/Extensions/LX/AvgSpeed').text.to_f
  end

  def reported_avg_speed=(value)
    @doc.at_xpath('//Activity/Lap/Extensions/LX/AvgSpeed').content = value.to_s
  end

  def reported_total_distance
    @doc.at_xpath('//Activity/Lap/DistanceMeters').text.to_f
  end

  def reported_total_distance=(value)
    @doc.at_xpath('//Activity/Lap/DistanceMeters').content = value
  end

  def reported_total_seconds
    @doc.at_xpath('//Activity/Lap/TotalTimeSeconds').text.to_f
  end

  def real_total_distance
    @doc.at_xpath('//Track[1]/Trackpoint[last()]/DistanceMeters').text.to_f
  end

  def real_total_seconds
    Time.iso8601(@doc.at_xpath('//Track[1]/Trackpoint[last()]/Time').text) -
      Time.iso8601(@doc.at_xpath('//Track[1]/Trackpoint[1]/Time').text)
  end

  def real_avg_speed
    total = trackpoints.inject(0) do |tot, t|
      speed_node = t.at_xpath('Extensions/TPX/Speed')
      tot += speed_node.nil? ? 0 : speed_node.text.to_f
      tot
    end
    total / trackpoints.length.to_f
  end

  def clip_after(options = {})
    succeeding_trackpoints = @doc.xpath("//Track[1]/Trackpoint[Time='#{options[:time]}']/following::Trackpoint")
    succeeding_trackpoints.each { |t| t.unlink }
    dirty!
  end

  private

  def dirty!
    @trackpoints  = nil

    recalculate_reported!
  end

  def recalculate_reported!
    self.reported_avg_speed = real_avg_speed
    self.reported_total_distance = real_total_distance
  end
end