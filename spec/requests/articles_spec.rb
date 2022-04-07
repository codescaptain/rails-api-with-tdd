require 'rails_helper'

RSpec.describe ArticlesController do

  describe 'GET #index' do
    it 'returns http success' do
      get '/articles'
      #expect(response.status).to eq(200)
      expect(response).to have_http_status(:success)
    end

    it 'returns a proper JSON' do
      article = create(:article)
      get '/articles'
      aggregate_failures do

        expect(json_data.size).to eq(1)
        expected = json_data.first
        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq('article')
        expect(expected[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug,
        )
      end

    end

    it 'returns article in proper order' do
      recent_article = create(:article)
      older_article = create(:article, created_at: 2.days.ago, slug: 'older-article')
      get '/articles'
      ids = json_data.map { |article| article[:id].to_i }
      expect(ids).to eq([recent_article.id, older_article.id])
    end

    it 'paginates result' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article2.id.to_s)
    end

    it 'containspagination links in the response' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(:first, :prev, :self, :next, :last)
    end
  end

  describe 'GET #show' do
    let!(:article) { create(:article) }

    subject { get "/articles/#{article.id}" }

    before { subject }

    it 'returns http success' do
      get "/articles/#{article.id}"
      expect(response).to have_http_status(:success)
    end

    it 'returns proper json' do

      aggregate_failures do
        expect(json_data[:id]).to eq(article.id.to_s)
        expect(json_data[:type]).to eq('article')
        expect(json_data[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug,
        )
      end
    end
  end
end