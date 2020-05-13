class WorksController < ApplicationController
  
  def index 
    @works = Work.all
  end
  
  def show 
    @work = Work.find_by(id: params[:id])
    
    if @work.nil?
      head :not_found
      return
    end
  end
  
  def new 
    @work = Work.new
  end
  
  def create
    @work = Work.new(work_params)
    
    if @work.save
      flash[:success] = "#{@work.title} was successfully saved."
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:error] = "A problem occurred: This #{@work.category} could not be created."
      render :new, status: :bad_request
    end
  end
  
  def edit
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    end
  end
  
  def update
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    elsif @work.update(work_params)
      flash[:success] = "#{@work.title} was successfully saved!"
      redirect_to work_path(@work.id)
    else
      flash.now[:error] = "A problem occurred: This #{@work.category} could not be updated."
      render :edit, status: :bad_request
    end
  end
  
  def destroy
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    else 
      @work.destroy
      redirect_to root_path
    end
  end
  
  private
  
  def works_params
    return params.require(:work).permit(:title, :category, :creator, :description, :publication_year)
  end
  
  
end
