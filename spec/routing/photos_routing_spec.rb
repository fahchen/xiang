require 'spec_helper'

describe PhotosController do
  describe 'routing' do

    it "should route to #create" do
      post('/photos').should route_to('photos#create')
    end

  end
end
