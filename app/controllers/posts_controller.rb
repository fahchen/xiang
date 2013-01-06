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
end
