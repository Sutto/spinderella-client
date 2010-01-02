require 'perennial/protocols/pure_ruby/json_transport'
require 'thread'

module Spinderella
  module Client
    class Subscriber < Perennial::Protocols::PureRuby::JSONTransport
      
      attr_writer :should_stop
      
      def initialize(options = {})
        @options       = options
        @host          = (options[:host] || "localhost").to_s
        @port          = (options[:port] || 42340).to_i
        @timeout       = (options[:timeout] || 15).to_f
        @read_timeout  = (options[:read_timeout] || 5).to_f
        @callbacks     = {}
        @mutex         = Mutex.new
        @should_stop   = false
      end
      
      def subscribe(*channels)
        write_message :subscribe, :channels => Array(channels)
        true
      end
      
      def unsubscribe(*channels)
        write_message :unsubscribe, :channels => Array(channels)
        true
      end
      
      def identify(identifier)
        write_message :identify, :identifier => identifier
        true
      end
      
      def channels
        write_message :channels
        action, payload = read_message(@read_timeout)
        if action == "channels"
          Array(payload["channels"])
        else
          []
        end
      end
      
      def watch
        loop do
          action, payload = read_message(@read_timeout)
          # When action is nil, it means there is nothing to read yet.
          case action
            when "ping"
              write_message :pong
            when "disconnected"
              @should_stop = true
              close
            when "receive_message"
              process_message(payload)
          end
          break if @should_stop
          # In the case we didn't receive data, sleep for half a second
          # so as not to steal all of the available CPU.
          sleep 0.5 if action.nil?
        end
      end
      
      def on_user(&blk)
        (@callbacks[:user] ||= []) << blk
        true
      end
      
      def on_channels(*channels, &blk)
        channel_callbacks = @callbacks[:channels] ||= {}
        (channel_callbacks[channels] ||= []) << blk
        true
      end
      
      def on_broadcast(&blk)
        (@callbacks[:broadcast] ||= []) << blk
        true
      end
      
      def stop
        @should_stop = true
      end
      
      protected
      
      def process_message(payload)
        type, message = payload["type"], payload["message"]
        case type
          when "user"
            Array(@callbacks[:user]).each { |cb| cb.call(message) }
          when "broadcast"
            Array(@callbacks[:broadcast]).each { |cb| cb.call(message) }
          when "channel", "channels"
            channels = Array(payload["channels"] || payload["channel"])
            channel_callbacks = @callbacks[:channels] ||= {}
            channel_callbacks.each_pair do |c, callbacks|
              p(channels & Array(c))
              callbacks.each { |cb| p cb; cb.call(message) } if !(channels & Array(c)).empty?
            end
        end
      end
      
      def write_message(name, data = {})
        @mutex.synchronize { super }
      end
      
      def read_message(timeout = nil)
        @mutex.synchronize { super }
      end
      
    end
  end
end