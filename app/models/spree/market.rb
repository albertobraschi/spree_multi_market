module Spree

  class Market < Struct.new(:code, :name, :alternative_codes, :currencies, :default_locale)

    def register_currencies
      currencies.each do |currency_code|
        base = ::Money::Currency.find(currency_code)
        new_code = "#{base.iso_code}-#{code.upcase}"

        ::Money::Currency.register({
          priority:             base.priority,
          iso_code:             new_code,
          iso_numeric:          base.iso_numeric,
          name:                 base.name,
          symbol:               base.symbol,
          subunit:              base.subunit,
          subunit_to_unit:      base.subunit_to_unit,
          separator:            base.separator,
          delimiter:            base.delimiter,
          symbol_first:         base.symbol_first,
          thousands_separator:  base.thousands_separator,
          html_entity:          base.html_entity,
          decimal_mark:         base.decimal_mark
        })
      end
    end

    def available_currencies
      currencies.map{ |c| "#{c}-#{code.upcase}"  }
    end

    class << self

      def default
        markets.try(:first)
      end

      def register(params)
        return if find(params[:code])

        market = Market.new(*params.values_at(:code, :name, :alternative_codes, :currencies, :default_locale))
        market.register_currencies

        markets << market
      end

      def all_currencies
        markets
          .map{|m| m.currencies
          .map{ |code| "#{code}-#{m.code.upcase}"} }
          .flatten
      end

      def find(code)
        markets.find{ |m| m.code.upcase == code.upcase }
      end

      private

      def markets
        SpreeMultiMarket::Markets
      end

    end

  end


end