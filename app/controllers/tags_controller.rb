class TagsController < ApplicationController
  require 'fileutils'
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :only_admin!, only: [:create, :destroy]
  # GET /tags
  # GET /tags.json
  def index
    page = params[:page] || 1
    page_size = params[:page_size] || 12

    tags = Tag.includes(:images).offset(page_size * (page - 1)).limit(page_size)
    tags = tags.order(created_at: :desc).offset(page_size * (page - 1)).limit(page_size)
    tags_count = tags.count
    @dto = PagedResponse.new(tags, tags_count, self.request.path, page, page_size)
    render 'tags/index'
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # POST /tags
  # POST /tags.json
  def create
    name = params[:name]
    description = params[:description]
    images = params[:images]
    # images.each do |image|
    path = Rails.root.join('public', 'images', 'tags')
    unless Dir.exist? path
      FileUtils.mkdir_p path
    end

    @tag = Tag.create(name: name, description: description)
    unless images.nil?
      images.each do |image|
        file_path = path.join(image.original_filename)

        File.open(file_path, 'wb') do |file|
          f = file.write(image.read)
          puts f
          @tag.images.build(type: TagImage.name, file_size: f, file_path: file_path.to_s.gsub(Rails.root.join('public').to_s, ''), file_name: image.original_filename, original_filename: image.original_filename)
        end
      end
    end
    urls = []
    @tag.images.each do |ti|
      urls.push ti.file_path
    end
    if @tag.save
      render json: {success: true, id: @tag.id, name: name,
                    description: description, full_messages: ['Tag created successfully'],
                    image_urls: urls}
    else
      render json: {success: false, name: name, full_messages: [description], errors: @tag.errors}
    end

  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html {redirect_to tags_url, notice: 'Tag was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.permit(:name, :description, images: [])
  end
end
