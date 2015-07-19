class PrintsController < ApplicationController
  before_action :set_print, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @prints = Print.all
  end



  def show
    @reviews = Review.where(print_id: @print.id).order("created_at DESC")
    if @reviews.blank?
      @avg_review = 0
    else
      @avg_review = @reviews.average(:rating).round(2)
    end 
  end


  def new
    @print = current_user.prints.build
  end

  
  def edit
  end


  def create
    @print = current_user.prints.build(print_params)

    respond_to do |format|
      if @print.save
        format.html { redirect_to @print, notice: 'Print was successfully created.' }
        format.json { render :show, status: :created, location: @print }
      else
        format.html { render :new }
        format.json { render json: @print.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @print.update(print_params)
        format.html { redirect_to @print, notice: 'Print was successfully updated.' }
        format.json { render :show, status: :ok, location: @print }
      else
        format.html { render :edit }
        format.json { render json: @print.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @print.destroy
    respond_to do |format|
      format.html { redirect_to prints_url, notice: 'Print was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_print
      @print = Print.find(params[:id])
    end

    def print_params
      params.require(:print).permit(:name, :description, :pledge, :rating, :category, :image)
    end
end
