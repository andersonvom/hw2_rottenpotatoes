require 'spec_helper'

describe Movie do

  it "should list all ratings" do
    Movie.ratings.should == ['G','PG','PG-13','R']
  end

end
