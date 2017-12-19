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
      @rate_zone = account["RateZone"]
      @total_billing_weight = "#{account["TotalBillingWeight"]["Value"]} #{account["TotalBillingWeight"]["Units"]}"

      @account_total_base_charge = account["TotalBaseCharge"]["Amount"]
      @account_total_freight_discounts = account["TotalFreightDiscounts"]["Amount"]
      @account_total_taxes = account["TotalTaxes"]["Amount"]
      @account_total_surcharges = account["TotalSurcharges"]["Amount"]
      @account_total_rebates = (account["TotalRebates"] || {})["Amount"]
      @account_total_net_charge = account["TotalNetCharge"]["Amount"]
      @account_total_net_fedex_charge = (account["TotalNetFeDexCharge"] || {})["Amount"]
      @account_total_net_freight = account["TotalNetFreight"]["Amount"]

      unless list.nil?
        @list_total_base_charge = list["TotalBaseCharge"]["Amount"]
        @list_total_freight_discounts = list["TotalFreightDiscounts"]["Amount"]
        @list_total_taxes = list["TotalTaxes"]["Amount"]
        @list_total_surcharges = list["TotalSurcharges"]["Amount"]
        @list_total_rebates = (list["TotalRebates"] || {})["Amount"]
        @list_total_net_charge = list["TotalNetCharge"]["Amount"]
        @list_total_net_fedex_charge = (list["TotalNetFeDexCharge"] || {})["Amount"]
        @list_total_net_freight = list["TotalNetFreight"]["Amount"]
      end
    end
  end
end