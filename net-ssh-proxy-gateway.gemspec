
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "net/ssh/proxy/gateway/version"

Gem::Specification.new do |spec|
  spec.name          = "net-ssh-proxy-gateway"
  spec.version       = Net::SSH::Proxy::Gateway::VERSION
  spec.authors       = ["Kontena, Inc"]
  spec.email         = ["info@kontena.io"]
  spec.license       = "Apache-2.0"

  spec.summary       = %q{Net::SSH::Proxy compatible tunneling over SSH}
  spec.description   = %q{Like using Net::SSH::Gateway but it can be passed to Net::SSH.start(proxy: ...)}
  spec.homepage      = "https://github.com/kontena/net-ssh-proxy-gateway"

  spec.files         = Dir["lib/net/ssh/proxy/gateway.rb", "lib/net/ssh/proxy/gateway/version.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "net-ssh-gateway", '~> 2.0', '>= 2.0.0'

  spec.add_development_dependency "rspec", "~> 3.0"
end
