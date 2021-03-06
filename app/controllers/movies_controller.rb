class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect_options = Hash.new
    session.delete(:ratings) if params[:ratings].blank? and not params[:commit].blank?
    [:order_by, :ratings].each do |opt|
      redirect_options.store opt, session[opt] if not session[opt].blank? and params[opt].blank?
      session[opt] = params[opt] unless params[opt].blank?
    end
    redirect_to movies_path(redirect_options.merge params) unless redirect_options.blank?

    @params = params
    @params[:ratings] ||= {}
    @column_name = Movie.attribute_names.clone.delete params[:order_by]
    @hilite = { @column_name => 'hilite' }
    @all_ratings = Movie.ratings
    @movies = Movie.order(@column_name)
    @movies = @movies.where(:rating => params[:ratings].keys) unless params[:ratings].blank?
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
