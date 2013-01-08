require "spec_helper"
describe Post do
  describe '.all_#{status}' do
    before(:all) do
      @draft_post1 = FactoryGirl.create(:post, status: 'draft')
      @draft_post2 = FactoryGirl.create(:post, status: 'draft')
      @draft_post3 = FactoryGirl.create(:post, status: 'draft')
      @published_post1 = FactoryGirl.create(:post, status: 'published')
      @published_post2 = FactoryGirl.create(:post, status: 'published')
      @published_post3 = FactoryGirl.create(:post, status: 'published')
      @spam_post1 = FactoryGirl.create(:post, status: 'spam')
      @spam_post2 = FactoryGirl.create(:post, status: 'spam')
      @spam_post3 = FactoryGirl.create(:post, status: 'spam')
    end

    it "should return all_draft posts" do
      all_draft = [@draft_post1, @draft_post2, @draft_post3]
      all_draft.delete_if{ |p| Post.all_draft.include?(p) }.should be_blank
    end

    it "should return all_published posts" do
      all_published = [@published_post1, @published_post2, @published_post3]
      all_published.delete_if{ |p| Post.all_published.include?(p) }.should be_blank
    end

    it "should return all_spam posts" do
      all_spam = [@spam_post1, @spam_post2, @spam_post3]
      all_spam.delete_if{ |p| Post.all_spam.include?(p) }.should be_blank
    end

  end

  describe '##{status}?' do
    let(:draft_post){ FactoryGirl.build(:post, status: 'draft') }
    let(:published_post){ FactoryGirl.build(:post, status: 'published') }
    let(:spam_post){ FactoryGirl.build(:post, status: 'spam') }

    it "should be draft" do
      draft_post.draft?.should be_true
      draft_post.published?.should be_false
      draft_post.spam?.should be_false
    end

    it "should be published" do
      published_post.draft?.should be_false
      published_post.published?.should be_true
      published_post.spam?.should be_false
    end

    it "should be spam" do
      spam_post.draft?.should be_false
      spam_post.published?.should be_false
      spam_post.spam?.should be_true
    end

  end

  describe '##to_#{status}' do
    before(:all) do
      @draft_post = FactoryGirl.create(:post, status: 'draft')
      @published_post = FactoryGirl.create(:post, status: 'published')
      @spam_post = FactoryGirl.create(:post, status: 'spam')
    end

    context 'when draft_post.to_#{status}' do
      it "should be draft" do
        @draft_post.to_draft
        @draft_post.status.should == 'draft'
        @published_post.to_draft
        @published_post.status.should == 'draft'
        @spam_post.to_draft
        @spam_post.status.should == 'draft'
      end
      
      it "should be published" do
        @draft_post.to_published
        @draft_post.status.should == 'published'
        @published_post.to_published
        @published_post.status.should == 'published'
        @spam_post.to_published
        @spam_post.status.should == 'published'
      end
      
      it "should be spam" do
        @draft_post.to_spam
        @draft_post.status.should == 'spam'
        @published_post.to_spam
        @published_post.status.should == 'spam'
        @spam_post.to_spam
        @spam_post.status.should == 'spam'
      end
      
    end
  end
  describe "Validates" do
    context "should success" do
      it "should save" do
        post = Post.new
        post.title = 'title'
        post.content = 'content'
        post.save.should_not be_false
      end

      it "should create slug without slug" do
        post = Post.new
        post.title = 'title-1'
        post.content = 'content'
        post.save
        post.slug.should == post.title
      end
    end
    context "should fail" do
      it "saving without title" do
        post = Post.new
        post.content = 'content'
        post.save.should be_false
      end

      it "saving the existing slug" do
        post = Post.create title: 'test-title-1', content: 'test-content-1', slug: 'test-slug-1'
        another_post = Post.new
        another_post.title = 'test-title-2'
        another_post.content = 'test-content-2'
        another_post.slug = 'test-slug-1'
        another_post.save.should be_false
        another_post.slug = 'test-slug-2'
        another_post.save.should_not be_false
      end

      it "saving status not included in STATUSES" do
        Post.create(title: 'title', content: 'content', status: 'test').should have(1).errors_on(:status)
      end
      it "saving category not included in CATEGORIES" do
        Post.create(title: 'title', content: 'content', category: 'test').should have(1).errors_on(:category)
      end
      it "saving source not included in SOURCES" do
        Post.create(title: 'title', content: 'content', source: 'test').should have(1).errors_on(:source)
      end
      
    end
  end
end