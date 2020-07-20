class Admin::StoresController < AdminController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to admin_stores_path, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to admin_stores_path, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to admin_stores_path, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_upload_stores
    xlsx = Roo::Excelx.new(params["store"]["stores"].tempfile, extension: :xlsx)
    xlsx.sheet(0).each_with_index do |row, index|
      next if index == 0
      Store.create!(store_name: row[0], category_tags: row[1], store_address: row[2], store_city: row[3], store_country: row[5], store_zip: row[6], store_phone: row[7], store_fax: row[8], store_email: row[9], store_website: row[10], store_link: row[11], stroe_description: row[12], operating_hours: row[13])
    end
    flash[:success] = "stores uploaded successfully"
    redirect_to admin_stores_path
  end

  def bulk_upload
    @store = Store.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:store_name, :store_address, :store_city, :store_country, :store_state, :store_zip, :store_phone, :store_email, :store_website, :store_link, :store_description, :store_on_time, :store_close_time, :vender_id, :lat, :long, :store_fax, :category_tags, :operating_hours, images: [])
    end
end
