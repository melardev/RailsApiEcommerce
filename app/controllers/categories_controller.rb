class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :only_admin!, only: [:create, :destroy]
  # GET /categories
  # GET /categories.json
  def index
    page = params[:page] || 1
    page_size = params[:page_size] || 12

    categories = Category.includes(:images).offset(page_size * (page - 1)).limit(page_size)
    categories = categories.order(created_at: :desc).offset(page_size * (page - 1)).limit(page_size)
    tags_count = categories.count
    @dto = PagedResponse.new(categories, tags_count, self.request.path, page, page_size)
    render 'categories/index'
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end


  # POST /categories
  # POST /categories.json
  def create
    name = params[:name]
    description = params[:description]
    images = params[:images]

    @category = Category.create(name: name, description: description)
    path = Rails.root.join('public', 'images', 'categories')

    unless Dir.exist? path
      FileUtils.mkdir_p path
    end
    images.each do |image|
      file_path = path.join(image.original_filename)

      File.open(file_path, 'wb') do |file|
        f = file.write(image.read)
        puts f
        @category.images.build(type: CategoryImage.name, file_size: f, file_path: file_path.to_s.gsub(Rails.root.join('public').to_s, ''), file_name: image.original_filename, original_filename: image.original_filename)
      end
    end

    urls = []
    @category.images.each do |ti|
      urls.push ti.file_path
    end

    if @category.save
      render json: {success: true, id: @category.id, name: name,
                    description: description, full_messages: ['Category created successfully'],
                    image_urls: urls}
    else
      render json: {success: false, name: name, full_messages: [description], errors: @category.errors}
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html {redirect_to @category, notice: 'Category was successfully updated.'}
        format.json {render :show, status: :ok, location: @category}
      else
        format.html {render :edit}
        format.json {render json: @category.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html {redirect_to categories_url, notice: 'Category was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:name, :description, images: [])
  end
end
