module Spree
  module CurrencyHelpers
    def self.included(receiver)
      receiver.send :helper_method, :supported_currencies
    end

    def supported_currencies
      Market.all_currencies.map { |code| ::Money::Currency.find(code) }
    end

    def set_current_market(market_code, currency=nil, overwrite=false)
      if (session[:market].blank? or overwrite) and market = Market.find(market_code)

        @current_market = market_code
        if currency.present? and market.available_currencies.include?(currency)
          @current_currency = currency
        else
          @current_currency = market.available_currencies.first
        end

        session[:market] = @current_market
        session[:currency] = @current_currency
        session[:locale] = market.default_locale

      end

    end

    def set_current_market_by_country(countries)
      if session[:market].blank?
        market = Market.find_by_countries(countries) || Market.default

        @current_market = market.code
        @current_currency = market.available_currencies.first

        session[:market] = @current_market
        session[:currency] = @current_currency
        session[:locale] = market.default_locale
      end
    end

  end
end
