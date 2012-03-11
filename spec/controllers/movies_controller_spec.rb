require 'spec_helper'

describe MoviesController do

  render_views

  describe "GET 'index'" do

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should be able to order movie list" do
      order_by = ['title', 'release_date']
      order_by.each do |order|
        get :index, :order_by => order
        assigns(:column_name).should == order
        assigns(:movies).order_clauses.should == [order]
      end
    end

    it "should have the correct header elements" do
      get :index
      response.should have_selector 'a', :id => 'title_header'
      response.should have_selector 'a', :id => 'release_date_header'
      response.should have_selector 'table', :id => 'movies' 
    end

    it "should highlight the correct table header" do
      order_by = ['title', 'release_date']
      order_by.each do |order|
        get :index, :order_by => order
        response.should have_selector 'th.hilite a', :id => "#{order}_header"
      end
    end

  end

end
