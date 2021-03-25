class Admin::CompaniesController < AdminController
  before_action :get_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = current_user.companies.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = current_user.companies.new(company_params)
    if @company.save
      @company.image.attach(params[:company][:image])
      flash[:success] = "Company Successfully Created"
      redirect_to admin_companies_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @company.update(company_params)
      flash[:success] = "Company Succesfully Updated"
      redirect_to admin_companies_path
    else
      render 'edit'
    end
  end

  def destroy
    @company.destroy
    flash[:danger] = "Company Successfully Deleted"
    redirect_to admin_companies_path
  end

  private

  def company_params
    params.required(:company).permit(:title, :address, :contact, :individual_experience , :user_id, :image)
  end

  def get_company
    @company = Company.find(params[:id])
  end
end
