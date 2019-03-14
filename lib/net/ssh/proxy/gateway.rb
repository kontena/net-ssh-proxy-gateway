require "net/ssh/proxy/gateway/version"
require 'net/ssh/gateway'
require 'socket'

module Net
  module SSH
    module Proxy
      # Net::SSH::Proxy::Gateway is like any Net::SSH::Proxy (Command, Jump, SOCKS, ..)
      # and can be passed to Net::SSH.start through the proxy: keyword.
      #
      # Internally it uses Net::SSH::Gateway from the net-ssh-gateway gem.
      class Gateway
        # @param host [String]
        # @param user [String]
        # @param gateway [Net::SSH::Gateway] allow passing in an existing gateway. host and user will be ignored.
        def initialize(host, user, gateway = nil, **options)
          if gateway
            @gateway = gateway
          else
            @gateway_options = [host, user, options]
          end
        end

        def gateway
          @gateway ||= Net::SSH::Gateway.new(*@gateway_options)
        end

        # @param host [String]
        # @param port [Integer]
        # @param connection_options [Hash]
        # @return [Socket]
        def open(host, port, connection_options = nil)
          ensure_connected!

          local_port = gateway.open(host, connection_options&.dig(:port) || 22)
          io = Socket.tcp('localhost'.freeze, local_port, nil, nil, connect_timeout: connection_options&.dig(:timeout))

          Thread.new(io, local_port, self) do |io, local_port, gateway|
            Thread.current.report_on_exception = false
            Thread.pass until io.closed?
            gateway.close(local_port)
          end

          io
        rescue StandardError => ex
          io&.close unless io&.closed?
          @gateway&.close(local_port) if local_port
          raise
        end

        # Shuts down the Net::SSH::Gateway instance
        def shutdown!
          @gateway&.shutdown!
          sleep 0.5 until !@gateway&.active?
          @gateway = nil
        end

        private

        def ensure_connected!
          unless @gateway&.active?
            @gateway = nil
          end
        end
      end
    end
  end
end
