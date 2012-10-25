require_relative '../spec_helper'

describe Facebook::Client::Adapter::FbGraph do
  before do
    @client = Facebook::Client.new(
      Facebook::Client::Fixtures.client_id,
      Facebook::Client::Fixtures.client_secret,
      adapter: :fb_graph
    )
  end

  describe "unauthenticated client" do
    before do
      @client = @client.unauthenticated
    end

    it "can decode signed requests" do
      decoded = @client.decode_signed_request(Facebook::Client::Fixtures.signed_request)

      decoded.must_equal Facebook::Client::Fixtures.signed_request_data
    end

    it "throws an AuthenticationError when decoding signed requests with the wrong secret" do
      @client.client.client_secret.reverse!
      lambda {
        @client.decode_signed_request(Facebook::Client::Fixtures.signed_request)
      }.must_raise Facebook::Client::Error::AuthenticationError
    end

    it "throws an AuthenticationError when the signature of the signed request is wrong" do
      lambda {
        @client.decode_signed_request(Facebook::Client::Fixtures.signed_request(bogus_signature: true))
      }.must_raise Facebook::Client::Error::AuthenticationError
    end

    it "can retrieve the auth url" do
      fb_auth_mock = MiniTest::Mock.new
      fb_auth_client_mock = MiniTest::Mock.new
      @client.client.adapter.instance_variable_set('@fb_auth', fb_auth_mock)
      fb_auth_mock.expect :client, fb_auth_client_mock

      url = 'http://redirect.example.com'
      scopes = [:bla, :blub]
      fb_auth_client_mock.expect :'redirect_uri=', nil, [url]
      fb_auth_client_mock.expect :'authorization_uri', nil, [{scope: scopes}]

      @client.authorization_url(redirect_url: url, scopes: scopes)

      fb_auth_client_mock.verify
    end

    it "can retrieve an apps URL" do
      @client.app_url.must_equal "https://www.facebook.com/apps/application.php?id=#{@client.client.client_id}"
    end
  end

  describe "authenticated client" do
    before do
      @access_token = 'some-token'
      @client = @client.authenticated_by(@access_token)
    end

    it "can retrieve a friends list" do
      user_id = '324556'
      ::FbGraph::User = MiniTest::Mock.new
      fb_user_mock = MiniTest::Mock.new
      ::FbGraph::User.expect :new, fb_user_mock, [user_id, {access_token: @access_token}]
      fb_user_mock.expect :fetch, nil
      fb_user_mock.expect :friends, []

      @client.friends_of(user_id)

      fb_user_mock.verify
    end

    it "can retrieve information about a token owner" do
      user_id = '539656'
      user_info = {
        'id' => user_id,
        'name' => 'Peter Smith',
        'email' => 'peter@example.com'
      }
      ::FbGraph::User = MiniTest::Mock.new
      fb_user_mock = MiniTest::Mock.new
      fb_user = MiniTest::Mock.new
      ::FbGraph::User.expect :me, fb_user, [@access_token]
      fb_user_data = Struct.new(:identifier, :name, :email).new(*user_info.values)
      fb_user.expect :fetch, fb_user_data

      @client.whoami.must_equal user_info
      fb_user_mock.verify
      fb_user.verify
    end
  end
end
