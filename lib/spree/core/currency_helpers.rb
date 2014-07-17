module Spree
  module CurrencyHelpers
    def self.included(receiver)
      receiver.send :helper_method, :supported_currencies
      receiver.send :helper_method, :current_market
    end

    def supported_currencies
      Market.all_currencies.map { |code| ::Money::Currency.find(code) }
    end

    def set_current_market(market_code, currency=nil, overwrite=false)
      if (session[:market].blank? or overwrite) and market = Market.find(market_code)

        @current_market = market
        if currency.present? and market.available_currencies.include?(currency)
          @current_currency = currency
        else
          @current_currency = market.available_currencies.first
        end

        session[:market] = @current_market.code
        session[:currency] = @current_currency
        session[:locale] = market.default_locale

      end

    end

    def set_current_market_by_country(countries)
      if session[:market].blank?
        market = Market.find_by_countries(countries) || Market.default

        @current_market = market
        @current_currency = market.available_currencies.first

        session[:market] = @current_market.code
        session[:currency] = @current_currency
        session[:locale] = market.default_locale
      end
    end

    def current_market
      @current_market ||= begin
        if session.key?(:market) and market = Spree::Market.find(session[:market])
          market
        else
          Spree::Market.default
        end
      end
    end

  end
end
