require "rails_helper"

RSpec.describe CommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "articles/1/comments").to route_to("comments#index", article_id: '1')
    end

    it "routes to #create" do
      expect(post: "/comments").to route_to("comments#create")
    end

  end
end
