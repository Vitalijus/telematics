# class Trackers::CreateUpdateTracker < Trackers::Base
#   attr_accessor :errors, :result
#
#   def initialize(data)
#     # super()
#     @data = data
#     # @token = token
#   end
#
#   def call
#     response = HTTP.headers(headers).post(base_address, params: { query: query(@data.flatten) })
#     response.parse
#   rescue StandardError => e
#     Rails.logger.error("============================ #{e.message} ===================================")
#     {}
#   end
#
#   def build_response
#     orders = call["data"] || {}
#
#     @errors = "Couldn't get ordersByPartyUuid" if orders.blank?
#     @result = counter(orders)
#   end
#
#   private
#
#   # def headers
#   #   { Authorization: "Bearer #{@token}" }
#   # end
#
#   def query(party_uuids)
#     <<~GQL
#       query ordersByPartyUuid {
#         ordersByPartyUuid(partyUuid: #{party_uuids}){
#           uuid
#           lineItems{
#             status
#           }
#         }
#       }
#     GQL
#   end
# end
