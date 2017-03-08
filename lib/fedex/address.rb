module Fedex
  class Address

    attr_reader :changes, :score, :confirmed, :available, :status, :residential,
                :business, :company, :street_lines, :city, :state, 
                :province_code, :postal_code, :country_code

    def initialize(options)
      @changes   = options["Changes"]
      @score     = options["Score"].to_i
      @confirmed = options["DeliveryPointValidation"] == "CONFIRMED"
      @available = options["DeliveryPointValidation"] != "UNAVAILABLE"

      @status      = options[:residential_status]
      @residential = status == "RESIDENTIAL"
      @business    = status == "BUSINESS"

      address        = options["Address"]

      @company       = options["CompanyName"]
      @street_lines  = address["StreetLines"]
      @city          = address["City"]
      @state         = address["StateOrProvinceCode"]
      @province_code = address["StateOrProvinceCode"]
      @postal_code   = address["PostalCode"]
      @country_code  = address["CountryCode"]

      @options = options
    end
  end
end
