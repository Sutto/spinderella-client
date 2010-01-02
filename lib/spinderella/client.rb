lib_path = File.expand_path(File.dirname(File.dirname(__FILE__)))
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

module Spinderella
  module Client
    autoload :Broadcaster, 'spinderella/client/broadcaster'
    autoload :Subscriber,  'spinderella/client/subscriber'
  end
end