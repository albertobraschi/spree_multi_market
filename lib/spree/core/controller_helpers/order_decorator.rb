Spree::Core::ControllerHelpers::Order.class_eval do

  def current_currency
    @current_currency ||= begin
      if session.key?(:currency) &&
        supported_currencies.map(&:iso_code).include?(session[:currency]) &&
        current_market.available_currencies.include?(session[:currency])

        session[:currency]
      else
        current_market.available_currencies.first
      end
    end

  end
end