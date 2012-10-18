require_relative '../spec_helper'

describe Facebook::Client::Adapter::FbGraph do
  before do
    @client = Facebook::Client.new(
      Facebook::Client::Fixtures.client_id,
      Facebook::Client::Fixtures.client_secret,
      adapter: :mock
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

    it "can retrieve a authorization url that has been set previously" do
      url = 'http://auth.example.com/mock'
      @client.client.adapter.authorization_url = url

      @client.authorization_url(redirect_url: 'http://some-other.example.com', scopes: []).must_equal(url)
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

      @client.client.adapter.friends[user_id] = [1,2,3]

      @client.friends_of(user_id).must_equal [1,2,3]
    end
  end
end
