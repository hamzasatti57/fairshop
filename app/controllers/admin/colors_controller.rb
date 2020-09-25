class Admin::ColorsController < AdminController
  before_action :get_color, only: [:show, :edit, :update, :destroy]

  def index
    @colors = Color.all
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)
    if @color.save
      flash[:success] = "Color Successfully Created"
      redirect_to admin_colors_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @color.update(color_params)
      flash[:success] = "Color Succesfully Updated"
      redirect_to  admin_colors_path
    else
      render 'edit'
    end
  end

  def destroy
    @color.destroy
    flash[:danger] = "Color Successfully Deleted"
    redirect_to admin_colors_path
  end

  private

  def color_params
    params.required(:color).permit(:title, :code, :image)
  end

  def get_color
    @color = Color.find(params[:id])
  end
end
