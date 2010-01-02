require 'perennial/protocols/pure_ruby/json_transport'

module Spinderella
  module Client
    class Broadcaster < Perennial::Protocols::PureRuby::JSONTransport
    
      def initialize(options = {})
        @authenticated = false
        @auth_callback = []
        @options       = options
        @host          = (options[:host] || "localhost").to_s
        @port          = (options[:port] || 42341).to_i
        @timeout       = (options[:timeout] || 15).to_f
        @read_timeout  = (options[:read_timeout] || 5).to_f
        @token         = options[:token]
        authenticate(@token) if @token
      end
    
      def authenticate(token)
        write_message(:authenticate, :token => token)
        action, payload = read_message(@timeout)
        @authenticated = (action == "authenticated")
        if @authenticated
          @auth_callback.each { |b| b.call }
          @auth_callback = []
        end
        @authenticated
      rescue NoConnection
        @authenticated = false
        return false
      end
    
      def authenticated?
        !!@authenticated
      end
    
      def close
        super
        @authenticated = false
      end
    
      def broadcast_to_all(message)
        once_authenticated do
          write_message :broadcast, "type" => "all", "message" => message.to_s
        end
      end
  
      def broadcast_to_users(message, users)
        once_authenticated do
          write_message :broadcast, "type" => "users", "message" => message.to_s,
            "users" => Array(users).map { |u| u.to_s }
        end
      end
  
      def broadcast_to_channels(message, channels)
        once_authenticated do
          write_message :broadcast, "type" => "channels", "message" => message.to_s,
            "channels" => Array(channels).map { |c| c.to_s }
        end
      end
  
      def broadcast_to_channel(message, channel)
        once_authenticated do
          write_message :broadcast, "type" => "channel", "message" => message.to_s, "channel" => channel.to_s
        end
      end
      
      def inspect
        "#<#{self.class.name} authenticated=#{authenticated?}, host=\"#{@host}:#{@port}\" connected=#{alive?}>"
      end
    
      protected
    
      def once_authenticated(&blk)
        if authenticated?
          blk.call
        else
          @auth_callback << blk
        end
        nil
      end
      
    end
    
  end
end