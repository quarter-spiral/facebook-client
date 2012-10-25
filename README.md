# Facebook::Client

Wrapper for the Quarter Spiral Facebook integration

## API

### Initialization

```ruby

```ruby
client = Facebook::Client.new(client_id, client_secret)
```

``client_id`` and ``client_secret`` are the the Facebook ``App ID`` and ``App Secret``.

### Decoding signed requests

[Facebook signed requests](https://developers.facebook.com/docs/howtos/login/signed-request/) can be decoded like this:

```ruby
client.unauthenticated.decode_signed_request(signed_request)
```

``signed_request`` is a string containing the signed request.

### Retrieve the authorization URL for an app

```ruby
client.authorization_url(redirect_url: 'http://some-other.example.com', scopes: [])
```

The ``authorization_url`` method takes an options hash:

* ``redirect_url``: A URL string where to redirect to after authorization (must comply to Facebook's policy and where you are allowed to redirect to!)
* ``scopes``: An Array of [Facebook permission scopes](https://developers.facebook.com/docs/reference/login/#permissions)

### Retrieve a list of friends of a user

```ruby
client.authenticated_by(access_token).friends_of(user_id)
```

First authenticate with an OAuth access token passed in as ``access_token``. You may obtain such a token e.g. from the parsed info from a signed request.

The ``user_id`` is the Facebook user's id who's friends you are trying to retrieve.

### Retrieve information about a user

```ruby
client.authenticated_by(access_token).whoami
```

Returns a hash like this:
```ruby
{
  'id' => '123456',
  'name' => 'Peter Smith',
  'email' => 'peter@example.com'
}
```

### Get an apps URL

```ruby
client.unauthenticated.app_url # => string with the app's URL
```

### Errors

In case of a failed authentication an ``Facebook::Client::Error::AuthenticationError`` is thrown. For all other domain related errors a ``Facebook::Client::Error::Base`` will be thrown.

## Testing

To use ``Facebook::Client`` in other projects' tests it's easy to enable a mock mode of the client that does not talk to Facebook at all. To do so just initialize the client like this:

```ruby
client = Facebook::Client.new(client_id, client_secret, adapter: :mock)
```

The mock client can decode signed requests just fine.

You should set a authorization URL like this:

```ruby
client.adapter.authorization_url = "http://redirect.example.com"
```

When you call

```ruby
client.authorization_url(redirect_url: 'http://some-other.example.com', scopes: [])
```

now you will get back ``http://redirect.example.com`` no matter what
you pass in.

You can also set a list of friends for a user:

```ruby
client.adapter.friends[user_id] = [1,2,3]
```

Whenever you call

```ruby
client.authenticated_by(access_token).friends_of(user_id)
```

you will now get back ``[1,2,3]``.

### Fixtures

The library also provides fixtures for commonly used Facebook data. To make use of that first

```ruby
require 'facebook-client/fixtures'
```

Then just use:

```ruby
Facebook::Client::Fixtures.client_id # => some facebook client id
Facebook::Client::Fixtures.client_secret # => some facebook client secret
```

In addition to that you can get signed request data.

```ruby
# Raw data:
Facebook::Client::Fixtures.signed_request_data # => hash with some data

# Signed request:
Facebook::Client::Fixtures.signed_request_data # => string with the signed request

# Signed request with wrong signature:
Facebook::Client::Fixtures.signed_request_data(bogus_signature: true)
# return a string with the signed request but an invalid signature
```
