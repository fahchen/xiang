class Comment < ActiveRecord::Base
  attr_accessible :content, :email, :name, :post_id
  belongs_to :post
end
