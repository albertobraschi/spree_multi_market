module SpreeMultiMarket
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_multi_market'

    require 'spree/core/currency_helpers'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree_multi_market.environment", :before => :load_config_initializers do |app|
      SpreeMultiMarket::Markets = []
    end

    def self.activate
      ['../../app/**/*_decorator*.rb', '../../lib/**/*_decorator*.rb'].each do |path|
        Dir.glob(File.join(File.dirname(__FILE__), path)) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      ApplicationController.send :include, Spree::CurrencyHelpers
    end

    config.to_prepare &method(:activate).to_proc
  end
end
