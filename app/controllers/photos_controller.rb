class PhotosController < ApplicationController
  before_filter :signed_in?
  def create
    src = FlickrUploader.upload(params[:Filedata].tempfile)
    render text: src
  end
end