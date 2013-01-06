class Post < ActiveRecord::Base
  attr_accessible :category, :content, :published_at, :slug, :status, :title, :source

  extend FriendlyId
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

  default_scope order('updated_at desc, published_at desc')

  SOURCES = ['origin', 'twitter', 'weibo', 'instagram']
  CATEGORIES = ['life', 'nonlife']
  STATUSES = ['draft', 'published', 'spam']
  validates :status, inclusion: { in: STATUSES }
  validates :category, inclusion: { in: CATEGORIES }

  class << self
    STATUSES.each do |status_name|
      define_method "all_#{status_name}" do
        where(status: status_name)
      end
    end

    STATUSES.each do |status_name|
      define_method "#{status_name}?" do
         self.status == status_name
      end
    end
  end

  STATUSES.each do |status_name|
    define_method "to_#{status_name}" do
       self.update_attributes status: status_name, published_at: Time.now
    end
  end

  before_validation :prepare_params
  validates :title, presence: true, if: Proc.new { |post| post.source == SOURCES.first }
  validates :content, presence: true
  validates :slug, uniqueness: true, if: Proc.new { |post| !post.slug.blank? }
  friendly_id :title, use: :slugged
  def should_generate_new_friendly_id?
    self.slug.blank?
  end

  protected
  def prepare_params
    self.source ||= SOURCES.first
    return false unless SOURCES.include?(self.source)
    unless self.source == SOURCES.first
      # 'test #xiang-slug#test' content for twitter or weibo
      self.content.gsub!(/#xiang-.+#/i) do |s|
        self.title = s.match(/#xiang-(.+)#/i)[1]
        ''
      end
    end
    self.category ||= CATEGORIES.first
    return false unless CATEGORIES.include?(self.category)
    if self.published_at.blank?
      self.published_at = Time.now
    end
  end

end
