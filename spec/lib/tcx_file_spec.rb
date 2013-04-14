require 'spec_helper'

describe TCXFile do
  before(:all) do
    @file = TCXFile.new(content_file('sample_activity.tcx'))
  end

  subject(:file)  { @file }

  it              { should have(1).laps }
  it              { should have(3370).trackpoints }

  its(:reported_avg_speed) { should eql(4.431000232696533) }
  its(:real_avg_speed)     { should eql(5.665456157569008) }

  its(:reported_total_distance)    { should eql(42981.54) }
  its(:real_total_distance)        { should eql(42981.53125) }
  its(:reported_total_seconds)     { should eql(9700.176) }
  its(:real_total_seconds)         { should eql(9704.0) }

  describe "A clipped file" do
    before(:all) { @file.clip_after(time: '2013-04-13T11:32:11.000Z') }

    it 'deletes all following trackpoints' do
      file.should have(3147).trackpoints
    end

    it 'recalculates the average speed' do
      file.real_avg_speed.should == 6.051869161249457
    end

    it 'sets the reported speed' do
      file.reported_avg_speed.should == 6.051869161249457
    end

    it 'recalculates the total distance' do
      file.real_total_distance.should == 42847.98046875
    end

    it 'sets the reported total distance' do
      file.reported_total_distance.should == 42847.98046875
    end
  end
end