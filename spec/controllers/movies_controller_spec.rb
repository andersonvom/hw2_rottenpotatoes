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

    it "should have the correct title header" do
      get :index
      response.should have_selector 'a', :id => 'title_header'
    end

    it "should have the correct release_date header" do
      get :index
      response.should have_selector 'a', :id => 'release_date_header'
    end

    it "should have the correct table element" do
      get :index
      response.should have_selector 'table', :id => 'movies' 
    end

    it "should highlight the correct table header" do
      order_by = ['title', 'release_date']
      order_by.each do |order|
        get :index, :order_by => order
        response.should have_selector 'th.hilite a', :id => "#{order}_header"
      end
    end

    it "should have a form to filter by rating" do
      get :index
      ratings = ['G','PG','PG-13','R']
      assigns(:all_ratings).should == ratings
      ratings.each do |r|
        response.should have_selector 'input', :id => "ratings_#{r}"
      end
    end

    it "should have a submit button for ratings filter" do
      get :index
      response.should have_selector 'input[type=submit]', :id => 'ratings_submit'
    end

    it "should check the correct boxes according to filter" do
      get :index, :ratings=>{"G"=>"1", "R"=>"1"}
      response.should have_selector 'form input#ratings_G', :checked => 'checked'
      response.should have_selector 'form input#ratings_R', :checked => 'checked'
      response.should_not have_selector 'form input#ratings_PG', :checked => 'checked'
    end

    it "should be able to filter and order the movies" do
      get :index, :ratings=>{"G"=>"1", "R"=>"1"}, :order_by => 'title'
      assigns(:movies).order_clauses.should == ['title']
      response.should have_selector 'form input#ratings_G', :checked => 'checked'
      response.should have_selector 'form input#ratings_R', :checked => 'checked'
    end

  end

end
