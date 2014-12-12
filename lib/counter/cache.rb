require "counter/cache/version"
require "counter/cache/active_record_reader"
require "counter/cache/active_record_updater"
require "counter/cache/options_parser"
require "counter/cache/config"
require "counter/cache/counters/buffer_counter"
require "counter/cache/redis"

module Counter

  module Cache
    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= Counter::Cache::Config.new
    end

    def self.included(base)
      base.instance_eval do
        def counter_cache_on(options)
          after_create ActiveRecordUpdater.new(options)
          after_destroy ActiveRecordUpdater.new(options)
        end

      attribute_method_prefix 'counter_cache_'
      end
    end

    def counter_cache_attribute(attr)
      ActiveRecordReader.new(self, attr).get
    end
  end
end
