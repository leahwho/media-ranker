class WorksController < ApplicationController
  
  before_action :find_work, only: [:destroy, :show, :edit, :update,]

  def index 
    @movies = Work.movies
    @books = Work.books
    @albums = Work.albums
  end
  
  def home 
    @movies = Work.movies[0..10]
    @books = Work.books[0..10]
    @albums = Work.albums[0..10]
    
    @spotlight = Work.media_spotlight
  end
  
  def show     
    if @work.nil?
      head :not_found
      return
    end
  end
  
  def new 
    @work = Work.new
  end
  
  def create
    @work = Work.new(works_params)
    
    if @work.save
      flash[:success] = "#{@work.title} was successfully saved."
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:danger] = "A problem occurred: This #{@work.category} could not be created."
      render :new, status: :bad_request
      return
    end
  end
  
  def edit    
    if @work.nil?
      head :not_found
      return
    end
  end
  
  def update    
    if @work.nil?
      head :not_found
      return
    elsif @work.update(works_params)
      flash[:success] = "#{@work.title} was successfully saved!"
      redirect_to work_path(@work.id)
      return
    else
      flash.now[:danger] = "A problem occurred: This #{@work.category} could not be updated."
      render :edit, status: :bad_request
      return
    end
  end
  
  def destroy
    if @work.nil?
      head :not_found
      return
    elsif @work.destroy
      flash[:success] = "#{@work.title} was successfully deleted."
      redirect_to root_path
      return
    else
      flash.now[:error] = "A problem occurred: This #{work.category} could not be deleted."
      redirect_to work_path(@work.id)
      return
    end
  end
  
  private
  
  def works_params
    return params.require(:work).permit(:title, :category, :creator, :description, :publication_year)
  end

  def find_work
    @work = Work.find_by(id: params[:id])
  end
  
end
