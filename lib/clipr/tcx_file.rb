require 'nokogiri'
require 'time'

module Clipr
  ##
  # A Garmin TCX file
  class TCXFile
    def initialize(tcx_str)
      @doc = Nokogiri::XML(tcx_str)
    end

    def ns
      @ns ||= {
          'goals' => 'http://www.garmin.com/xmlschemas/ActivityGoals/v1',
          'ext'   => 'http://www.garmin.com/xmlschemas/ActivityExtension/v2',
          'prof'  => 'http://www.garmin.com/xmlschemas/UserProfile/v2',
          'g'     => 'http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2',
          'pext'  => 'http://www.garmin.com/xmlschemas/ProfileExtension/v1'
      }
    end

    ##
    # Lap nodes
    def laps
      @laps ||= @doc.xpath('//g:Activity/g:Lap', ns)
    end

    ##
    # Trackpoint nodes
    def trackpoints
      @trackpoints ||= @doc.xpath('//g:Track[1]/g:Trackpoint', ns)
    end

    def reported_avg_speed
      @doc.xpath('//g:Activity/g:Lap/g:Extensions/ext:LX/ext:AvgSpeed', ns).text.to_f
    end

    def reported_avg_speed=(value)
      @doc.at_xpath('//g:Activity/g:Lap/g:Extensions/ext:LX/ext:AvgSpeed', ns).content = value.to_s
    end

    def reported_max_speed
      @doc.xpath('//g:Activity/g:Lap/g:MaximumSpeed', ns).text.to_f
    end

    def reported_max_speed=(value)
      @doc.at_xpath('//g:Activity/g:Lap/g:MaximumSpeed', ns).content = value.to_s
    end

    def real_max_speed
      @doc.xpath('//g:Track[1]/g:Trackpoint/g:Extensions/ext:TPX/ext:Speed', ns).inject(0.0) do |max, current|
        [max, current.content.to_f].max
      end
    end

    def reported_total_distance
      @doc.at_xpath('//g:Activity/g:Lap/g:DistanceMeters', ns).text.to_f
    end

    def reported_total_distance=(value)
      @doc.at_xpath('//g:Activity/g:Lap/g:DistanceMeters', ns).content = value
    end

    def reported_total_seconds
      @doc.at_xpath('//g:Activity/g:Lap/g:TotalTimeSeconds', ns).text.to_f
    end

    def real_total_distance
      @doc.at_xpath('//g:Track[1]/g:Trackpoint[last()]/g:DistanceMeters', ns).text.to_f
    end

    def real_total_seconds
      Time.iso8601(@doc.at_xpath('//g:Track[1]/g:Trackpoint[last()]/g:Time', ns).text) -
          Time.iso8601(@doc.at_xpath('//g:Track[1]/g:Trackpoint[1]/g:Time', ns).text)
    end

    def real_avg_speed
      total = trackpoints.inject(0) do |tot, t|
        speed_node = t.at_xpath('g:Extensions/ext:TPX/ext:Speed', ns)
        tot += speed_node.nil? ? 0 : speed_node.text.to_f
        tot
      end
      total / trackpoints.length.to_f
    end

    def clip_after(options = {})
      succeeding_trackpoints = @doc.xpath("//g:Track[1]/g:Trackpoint[g:Time='#{options[:time]}']/following::g:Trackpoint", ns)
      succeeding_trackpoints.each { |t| t.unlink }
      dirty!
    end

    def save(filename)
      File.open(filename, 'w') do |file|
        file.write(@doc)
      end
    end

    private

    def dirty!
      @trackpoints = nil

      recalculate_reported!
    end

    def recalculate_reported!
      self.reported_avg_speed = real_avg_speed
      self.reported_total_distance = real_total_distance
      self.reported_max_speed = real_max_speed
    end
  end
end