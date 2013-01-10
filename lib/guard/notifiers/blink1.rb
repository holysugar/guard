require 'rbconfig'
require 'guard/ui'

module Guard
  module Notifier
    module Blink1
      extend self

      DEFAULT_COMMAND = 'blink1-tool'

      def available?(silent = false)
        require 'blink1'
        true
      rescue LoadError
        ::Guard::UI.error "Please add \"gem 'rb-blink1'\" to your Gemfile and run Guard with \"bundle exec\"." unless silent
        false
      end

      def notify(type, title, message, image, options = {})
        require 'blink1'

        blink1 = ::Blink1.new
        blink1.open
        blink1.set_rgb(0, 0, 0)

        case type
        when "success"
          blink1.delay_millis = 1000
          blink1.blink(0, 0xff, 0, 1)
        when "pending"
          blink1.delay_millis = 1000
          blink1.blink(0xff, 0xff, 0, 1)
          #system "#{command} --rgb 0xff,0xff,0 --blink 1 -t 1000 #{option} &"
        when "failed"
          blink1.blink(0xff, 0, 0, 3)
          #system "#{command} --rgb 0xff,0,0 --blink 3 #{option} &"
        else
          # do nothing
        end

        blink1.close

      end
    end
  end
end
