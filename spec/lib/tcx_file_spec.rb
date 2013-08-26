require 'spec_helper'

describe Clipr::TCXFile do
  before(:all) do
    @file = Clipr::TCXFile.new(content_file('sample_activity.tcx'))
  end

  subject(:file) { @file }

  it { should have(1).laps }
  it { should have(3370).trackpoints }

  its(:reported_avg_speed) { should eql(4.431000232696533) }
  its(:real_avg_speed) { should eql(5.665456157569008) }

  its(:reported_total_distance) { should eql(42981.54) }
  its(:real_total_distance) { should eql(42981.53125) }
  its(:reported_total_seconds) { should eql(9700.176) }
  its(:real_total_seconds) { should eql(9704.0) }

  describe "A clipped file" do
    before(:all) { @file.clip_after(time: '2013-04-13T11:32:11.000Z') }

    it 'deletes all following trackpoints' do
      file.should have(3147).trackpoints
    end

    it 'calculates the average speed' do
      file.real_avg_speed.should == 6.051869161249457
    end

    it 'sets the reported speed' do
      file.reported_avg_speed.should == 6.051869161249457
    end

    it 'calculates the total distance' do
      file.real_total_distance.should == 42847.98046875
    end

    it 'sets the reported total distance' do
      file.reported_total_distance.should == 42847.98046875
    end

    it 'calculates the maximum speed' do
      file.real_max_speed.should == 14.213000297546387
    end

    it 'sets the maximum speed' do
      file.reported_max_speed.should == 14.213000297546387
    end

    it 'calculates the total time' do
      file.real_total_seconds.should == 8091.0
    end

    it 'sets the total time' do
      file.reported_total_seconds.should == 8091.0
    end

    describe 'The saved file' do
      before :all do
        saved_name = content_filename('saved.tcx')
        File.delete(saved_name) rescue nil

        @file.save(saved_name).should be_true

        @loaded_str = content_file('saved.tcx')
      end

      context 'as xml' do
        subject(:loaded_xml) { Nokogiri::XML(@loaded_str) }

        it 'has one activity in the Garmin namespace' do
          loaded_xml.xpath('//xmlns:Activity').should have(1).node
        end

        it 'has the correct speed' do
          loaded_xml.xpath('//xmlns:Lap/xmlns:TotalTimeSeconds').text.to_f.should == 8091.0
        end
      end
    end
  end

  describe 'A file with trackpoints that have no distance' do
    before(:all) do
      @file = Clipr::TCXFile.new(content_file('tony.tcx'))
    end

    its(:real_total_distance) { should eql(53917.5) }
  end
end