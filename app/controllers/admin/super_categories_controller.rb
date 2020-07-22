class Admin::SuperCategoriesController < ApplicationController
  before_action :get_super_category, only: [:show, :edit, :update, :destroy]

  def index
    @super_categories = SuperCategory.all
  end

  def new
    @super_category = SuperCategory.new
  end

  def create
    @super_category = SuperCategory.new(super_category_params)
    if @super_category.save
      # @super_category.punch(request)
      flash[:success] = "Super Category Successfully Created"
      redirect_to admin_super_categories_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @super_category.update(super_category_params)
      flash[:success] = "Super Category Succesfully Updated"
      redirect_to admin_super_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    @super_category.destroy
    flash[:danger] = "Super Category Successfully Deleted"
    redirect_to admin_super_categories_path
  end

  private

  def super_category_params
    params.required(:super_category).permit(:title)
  end

  def get_super_category
    @super_category = SuperCategory.find(params[:id])
  end
end
