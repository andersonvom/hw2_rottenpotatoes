require 'spec_helper'

describe "Movie Links" do

  it "should be able to filter and then sort movies at the same time" do
    visit movies_path
    click_link "Movie Title"
    check 'ratings_G'
    click_button "Refresh"
    assigns(:movies).order_clauses.should == ['title']
  end

  it "should be able to sort and the filter movies at the same time" do
    visit movies_path
    check 'ratings_G'
    click_button "Refresh"
    click_link "Movie Title"
    assigns(:movies).where_values_hash.should == {:rating=>["G"]}
  end

  it "should remember the sort and filter settings" do
    visit movies_path
    check 'ratings_G'
    click_button "Refresh"
    click_link "Movie Title"
    get movies_path
    response.should redirect_to movies_path(:order_by=>'title', :ratings=>{"G"=>1})
  end

end
