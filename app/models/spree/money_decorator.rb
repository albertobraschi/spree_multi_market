unless Spree::Money.private_instance_methods.include? :old_initialize
  Spree::Money.class_eval do

    alias_method :old_initialize, :initialize

    def initialize(amount, options={})
      options[:currency] = options[:currency].split('-').first if options[:currency].present?
      old_initialize(amount, options)
    end

  end
end