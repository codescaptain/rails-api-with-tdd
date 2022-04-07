require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validations' do
    let!(:article) { build(:article) }

    it 'tests article object' do
      expect(article).to be_valid
    end

    it 'article has an invalid title' do
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'article has an invalid slug' do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include("can't be blank")
    end

    it 'article has to uniq slug' do
      article2 = create(:article, slug: 'test-article-2')
      article.slug = 'test-article-2'
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include('has already been taken')
    end

    it 'article has an invalid content' do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end
  end

  describe '.recent' do
    it 'returns the most recent articles' do
      article1 = create(:article, slug: 'deneme-1' )
      article2 = create(:article, created_at: 2.hours.ago, slug: 'deneme-2' )
      article3 = create(:article, created_at: 3.hours.ago, slug: 'deneme-3' )

      expect(Article.recent).to eq([article1, article2, article3])
    end
  end

end
