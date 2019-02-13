class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :only_admin!, except: [:index, :show]

  def index
    page = params[:page] || 1
    page_size = params[:page_size] || 8

    @products = Product.order(created_at: :desc).offset(page_size * (page - 1)).limit(page_size)
    @products_count = Product.count
    @dto = ProductListDto.new(@products, @products_count, self.request.path, page, page_size)
    render :list
  end


  def show
  end


  def create
    @dto = ProductCreateOrEditDto.new(params)

    tags = get_or_create_tags @dto
    categories = get_or_create_categories @dto

    @product = Product.new(@dto.get_params)

    @product.categories = categories unless categories.blank?
    @product.tags = tags unless tags.blank?

    path = Rails.root.join('public', 'images', 'products')
    unless Dir.exist? path
      FileUtils.mkdir_p path
    end
    images = @dto.get_images
    unless images.nil?
      images.each do |image|
        file_path = path.join(image.original_filename)

        File.open(file_path, 'wb') do |file|
          f = file.write(image.read)
          puts f
          @product.images.build(type: ProductImage.name, file_size: f, file_path: file_path.to_s.gsub(Rails.root.join('public').to_s, ''), file_name: image.original_filename, original_filename: image.original_filename)
        end
      end
    end

    if @product.save
      render :show
    else
      render_error(@product.errors)
      # render json: {success: false, errors: @article.errors, full_messages: @article.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

    @dto = ProductCreateOrEditDto.new(params)

    tags = get_or_create_tags @dto
    categories = get_or_create_categories @dto

    params = @dto.get_params.merge!(tags: tags, categories: categories)
    if @product.update_attributes(params)
      render :show
    else
      render_error(@product.errors)
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if @product.destroy
      render_success 'Deleted successfully'
    else
      render_error({delete: 'Failed to delete'})
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    # check if id is id or slug
    if !!(params[:id] =~ /\A[-+]?[0-9]+\z/)
      # is integer, so id, get by id
      @product = Product.find(params[:id])
    else
      @product = Product.find_by(slug: params[:id])
    end

    # @product = Product.find_by_slug(params[:slug])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:content_type, :description, :name, :price, :publish_on, :quantity, :slug)
  end

  def get_or_create_tags(dto)
    tags = []
    if dto.has_tags?
      tags_dto = @dto.get_tags
      tags_dto.each do |tag|
        tags.append Tag.create_with(description: tag[:description] || '').find_or_create_by(name: tag[:name])
      end
    end
    tags
  end

  def get_or_create_categories(dto)
    categories = []
    if dto.has_categories?
      categories_dto = @dto.get_categories
      categories_dto.each do |category|
        categories.append Category.create_with(description: category[:description] || '').find_or_create_by(name: category[:name])
      end
    end
    categories
  end
end
