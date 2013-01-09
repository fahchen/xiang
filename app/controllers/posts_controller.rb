class PostsController < ApplicationController
  before_filter :require_admin, except: [:index, :show]
  # layout 'admin'
  def new
    @post = Post.new
    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end
  def create
    prepare_published_at
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to show_path(@post) }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  def edit
    @post = Post.find(params[:id])
    render 'new'
  end
  def update
    @post = Post.find(params[:id])
    prepare_published_at
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to show_path(@post), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end
  def show
    @post = Post.all_published.find_by_slug!(params[:slug])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
  def index
    @posts = Post.page params[:page]
  end
  def preview
    content = XiangMarkdownConverter.preview_markdwon( params[:content] )
    render json: { content: content }
  end

  protected
  def prepare_published_at
    # binding.pry
    published_at = params[:post][:published_at]
    if published_at.to_s.match(/^\d{4}-\d{2}-\d{2}$/)
      published_at = Time.now.to_s.gsub(/\d{4}-\d{2}-\d{2}/, published_at)
    end
    params[:post][:published_at] = published_at
  end
end
