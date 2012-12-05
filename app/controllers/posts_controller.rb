class PostsController < ApplicationController
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
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  def show
    @post = Post.all_published.find_by_slug!(params[:slug])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
  def index
    @posts = Post.all
  end
end
