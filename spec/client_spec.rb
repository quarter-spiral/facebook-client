require_relative './spec_helper'

describe Facebook::Client do
  before do
    @client_id = Facebook::Client::Fixtures.client_id
    @client_secret = Facebook::Client::Fixtures.client_secret
  end
  describe "available adapters" do
    it "include fb_graph" do
      client = Facebook::Client.new(@client_id, @client_secret, adapter: :fb_graph)
      client.adapter.kind_of?(Facebook::Client::Adapter::FbGraph).must_equal true
    end

    it "include mock" do
      client = Facebook::Client.new(@client_id, @client_secret, adapter: :mock)
      client.adapter.kind_of?(Facebook::Client::Adapter::Mock).must_equal true
    end

    it "defaults to fb_graph" do
      client = Facebook::Client.new(@client_id, @client_secret)
      client.adapter.kind_of?(Facebook::Client::Adapter::FbGraph).must_equal true
    end
  end
end

