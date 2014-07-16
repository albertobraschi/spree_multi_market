unless Spree::Money.private_instance_methods.include? :old_initialize
  Spree::Money.class_eval do

    alias_method :old_initialize, :initialize

    def initialize(amount, options={})
      old_initialize(amount, options)

      @money = Monetize.parse(amount.to_s, (options[:currency] || Spree::Config[:currency]))
    end

  end
end