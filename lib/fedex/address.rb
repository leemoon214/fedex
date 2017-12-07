module Fedex
  class Address

    attr_reader :state, :status, :residential,
                :business, :street_lines, :city, :state,
                :province_code, :postal_code, :country_code, :status,
                :attributes

    def initialize(options)
      @state         = options["State"]
      @attributes    = options["Attributes"]

      @status      = options["Classification"]
      @residential = status == "RESIDENTIAL"
      @business    = status == "BUSINESS"

      address        = options["EffectiveAddress"]

      @street_lines  = [address["StreetLines"]].flatten
      @city          = address["City"]
      @state         = address["StateOrProvinceCode"]
      @province_code = address["StateOrProvinceCode"]
      @postal_code   = address["PostalCode"]
      @country_code  = address["CountryCode"]

      @options = options
    end
  end
end
