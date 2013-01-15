FactoryGirl.define do
  sequence(:title){|n| "title-#{n}" }
  sequence(:content){|n| "content-#{n}" }
  sequence(:slug) { |n| "slug-#{n}" }
  factory :post do
    title
    content
    slug
    category 'life'
    published_at Time.now
    status 'published'
    source 'origin'
    identifier {"#{Time.now.to_i}#{(0...8).map{65.+(rand(26)).chr}.join}"}
  end
end
