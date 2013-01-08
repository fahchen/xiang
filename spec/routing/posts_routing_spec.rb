require 'spec_helper'

describe PostsController do
  describe 'routing' do

    it 'should route to #index' do
      get('/').should route_to('posts#index')
    end

    it 'should route to #new' do
      get('/admin/writing').should route_to('posts#new')
      get('/posts/new').should route_to('posts#new')
    end

    it 'should route to #edit' do
      get('/posts/1/edit').should route_to('posts#edit', :id => '1')
    end

    it 'should route to #create' do
      post('/posts').should route_to('posts#create')
    end

    it 'should route to #preview' do
      post('/posts/preview').should route_to('posts#preview')
    end

    it 'should route to #update' do
      put('/posts/1').should route_to('posts#update', id: '1')
    end

    it 'should route to #destroy' do
      delete('/posts/1').should route_to('posts#destroy', id: '1')
    end

    it 'should route to #show' do
      get('/slug-1').should route_to('posts#show', slug: 'slug-1')
    end

  end
end
