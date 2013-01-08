require 'spec_helper'

describe SessionsController do
  describe 'routing' do

    it "should route to #create" do
      get('/sign_in').should route_to('sessions#new')
    end

    it "should route to #create" do
      post('/sessions').should route_to('sessions#create')
    end

    it "should route to #destroy" do
      delete('/sign_out').should route_to('sessions#destroy')
    end

  end
end
