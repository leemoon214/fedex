require 'fedex/request/base'

module Fedex
  module Request
    class Rate < Base
      # Sends post request to Fedex web service and parse the response, a Rate object is created if the response is successful
      def process_request
        api_response = self.class.post(api_url, :body => build_xml)
        puts api_response if @debug
        #response = parse_response(api_response)
        response = api_response
        if success?(response)
          rate_reply_details = response["RateReply"]["RateReplyDetails"] || []
          rate_reply_details = [rate_reply_details] if rate_reply_details.is_a?(Hash)

          rate_reply_details.map do |rate_reply|
            rate_details = {}
            rated_shipment_details = [rate_reply["RatedShipmentDetails"]].flatten
            account_rate = rated_shipment_details.select{|r| r["ShipmentRateDetail"]["RateType"] == 'PAYOR_ACCOUNT_SHIPMENT'}.first || rated_shipment_details.select{|r| r["ShipmentRateDetail"]["RateType"] == 'PAYOR_ACCOUNT_PACKAGE'}.first
            rate_details[:account] = account_rate["ShipmentRateDetail"]
            list_rate = rated_shipment_details.select{|r| r["ShipmentRateDetail"]["RateType"] == 'PAYOR_LIST_PACKAGE'}.first
            rate_details[:list] = list_rate["ShipmentRateDetail"] unless list_rate.nil?
            rate_details.merge!(service_type: rate_reply["ServiceType"])
            rate_details.merge!(transit_time: rate_reply["TransitTime"])
            Fedex::Rate.new(rate_details)
          end
        else
          error_message = if response["RateReply"]
            [response["RateReply"]["Notifications"]].flatten.first["MessageParameters"]["Value"]
          else
            #"#{api_response["Fault"]["detail"]["fault"]["reason"]}\n--#{api_response["Fault"]["detail"]["fault"]["details"]["ValidationFailureDetail"]["message"].join("\n--")}"
            "#{api_response["CSRError"]["code"]}\n--#{api_response["CSRError"]["message"]}"
          end
          raise RateError, error_message
        end
      end

      private

      # Add information for shipments
      def add_requested_shipment(xml)
        xml.RequestedShipment{
          xml.DropoffType @shipping_options[:drop_off_type] ||= "REGULAR_PICKUP"
          xml.ServiceType service_type if service_type
          xml.PackagingType @shipping_options[:packaging_type] ||= "YOUR_PACKAGING"
          add_shipper(xml)
          add_recipient(xml)
          add_shipping_charges_payment(xml)
          add_customs_clearance(xml) if @customs_clearance_detail
          xml.RateRequestTypes "LIST" unless @smartpost_details
          add_smartpost_details(xml) if @smartpost_details
          add_packages(xml)
        }
      end

      # Add transite time options
      def add_transit_time(xml)
        xml.ReturnTransitAndCommit true
      end

      # Build xml Fedex Web Service request
      def build_xml
        ns = "http://fedex.com/ws/rate/v#{service[:version]}"
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.RateRequest(:xmlns => ns){
            add_web_authentication_detail(xml)
            add_client_detail(xml)
            add_version(xml)
            add_transit_time(xml)
            add_requested_shipment(xml)
          }
        end
        builder.doc.root.to_xml
      end

      def service
        { :id => 'crs', :version => Fedex::API_VERSION }
      end

      # Successful request
      def success?(response)
        response["RateReply"] &&
          %w{SUCCESS WARNING NOTE}.include?(response["RateReply"]["HighestSeverity"])
      end

    end
  end
end
