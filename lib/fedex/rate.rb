module Fedex
  # Visit {http://www.fedex.com/us/developer/ Fedex Developer Center} for a complete list of values returned from the API
  #
  # Rate totals are contained in the node
  #    response[:rate_reply][:rate_reply_details][:rated_shipment_details]
  class Rate
    # Initialize Fedex::Rate Object
    # @param [Hash] options
    #
    #
    # return [Fedex::Rate Object]
    #     @rate_zone #Indicates the rate zone used(based on origin and destination)
    #     @total_billing_weight #The weight used to calculate these rates
    # apply the same for account and list rates
    #     @total_freight_discounts #The toal discounts used in the rate calculation
    #     @total_net_charge #The net charge after applying all discounts and surcharges
    #     @total_taxes #Total of the transportation-based taxes
    #     @total_net_freight #The freight charge minus dicounts
    #     @total_surcharges #The total amount of all surcharges applied to this shipment
    #     @total_base_charge #The total base charge
    attr_accessor :service_type, :transit_time, :rate_zone,
                  :total_billing_weight,
                  :account_total_freight_discounts,
                  :account_total_net_charge,
                  :account_total_taxes,
                  :account_total_net_freight,
                  :account_total_surcharges,
                  :account_total_base_charge,
                  :list_total_freight_discounts,
                  :list_total_net_charge,
                  :list_total_taxes,
                  :list_total_net_freight,
                  :list_total_surcharges,
                  :list_total_base_charge
    def initialize(options = {})
      @service_type = options[:service_type]
      @transit_time = options[:transit_time]
      account = options[:account]
      list = options[:list]
      @rate_zone = account[:rate_zone]
      @total_billing_weight = "#{account[:total_billing_weight][:value]} #{account[:total_billing_weight][:units]}"

      @account_total_base_charge = account[:total_base_charge][:amount]
      @account_total_freight_discounts = account[:total_freight_discounts][:amount]
      @account_total_taxes = account[:total_taxes][:amount]
      @account_total_surcharges = account[:total_surcharges][:amount]
      @account_total_rebates = (account[:total_rebates]||{})[:amount]
      @account_total_net_charge = account[:total_net_charge][:amount]
      @account_total_net_fedex_charge = (account[:total_net_fe_dex_charge]||{})[:amount]
      @account_total_net_freight = account[:total_net_freight][:amount]

      @list_total_base_charge = list[:total_base_charge][:amount]
      @list_total_freight_discounts = list[:total_freight_discounts][:amount]
      @list_total_taxes = list[:total_taxes][:amount]
      @list_total_surcharges = list[:total_surcharges][:amount]
      @list_total_rebates = (list[:total_rebates]||{})[:amount]
      @list_total_net_charge = list[:total_net_charge][:amount]
      @list_total_net_fedex_charge = (list[:total_net_fe_dex_charge]||{})[:amount]
      @list_total_net_freight = list[:total_net_freight][:amount]
    end
  end
end