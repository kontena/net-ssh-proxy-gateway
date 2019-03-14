[![Build Status](https://travis-ci.org/kontena/net-ssh-proxy-gateway.svg?branch=master)](https://travis-ci.org/kontena/net-ssh-proxy-gateway)
[![Gem Version](https://badge.fury.io/rb/net-ssh-proxy-gateway)](https://badge.fury.io/rb/net-ssh-proxy-gateway)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/gems/net-ssh-proxy-gateway)

# Net::SSH::Proxy::Gateway

Allows using [`Net::SSH::Gateway`](https://github.com/net-ssh/net-ssh-gateway) as a proxy in `Net::SSH.start(host, user, proxy:..)`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'net-ssh-proxy-gateway'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install net-ssh-proxy-gateway

## Usage

It accepts the same parameters as [`Net::SSH::Gateway.new`](https://www.rubydoc.info/github/net-ssh/net-ssh-gateway) which works quite a lot like [`Net::SSH.start`](https://www.rubydoc.info/github/net-ssh/net-ssh/Net%2FSSH.start).

### Example

```ruby
session = Net::SSH.start(
  'target-host-name-or-ip.example.com',
  'target-host-username',
  proxy: Net::SSH::Proxy::Gateway.new(
    'proxy-host-hostname-or-ip.example.com',
    'proxy-host-username',
    #proxy_host_connection_options (see Net::SSH.start)
  )
)
```

Tada! The session to the target host will be tunneled through the proxy host. Nothing else for you to do. The port forwarding will be automatically canceled when the main session is closed.

## Contributing

Bug reports and pull requests are welcome on GitHub at [kontena/net-ssh-proxy-gateway](https://github.com/kontena/net-ssh-proxy-gateway).
