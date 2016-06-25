class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Select sort method then store it in session hash
    # Try to use user input, then fall back to existing session, then fall back to default
    if params[:sort]
      @sort = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
    else
      @sort = :id
    end
    session[:sort] = @sort
    # Select ratings to display then store them in session hash.
    # Try to use user input, then fall back to existing session, then fall back to default
    @all_ratings = Movie.ratings
    if params[:ratings]
      @selected = params[:ratings]
    elsif session[:selected]
      @selected = session[:selected]
    else
      @selected = @all_ratings
    end
    session[:selected] = @selected
    # Highlight the selected sort column
    @title_class = "hilite" if @sort == "title"
    @release_class = "hilite" if @sort == "release_date"
    # Filter database per user selections
    @movies = Movie.where(rating: @selected.keys).order(@sort)
    # Build up complete RESTful URI regardless of user input
    if params[:sort].nil? || params[:ratings].nil?
      flash.keep
      redirect_to movies_path(:sort => @sort, :ratings => @selected) and return
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
