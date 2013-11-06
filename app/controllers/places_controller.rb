class PlacesController < ApplicationController
	rescue_from Savon::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH, HTTPClient::ConnectTimeoutError, with: :SOAPerror

	# GET places
	# GET places.json
	# GET places.xml
	def index
		@parking_places = Rails.cache.fetch('parking_places') {
			fetch_parking_places
		}

		respond_to do |format|
			format.html
			format.json { render json:@parking_places }
			format.xml { render xml:@parking_places }
		end
	end

	# GET /places/name
	# GET /places/name.json
	# GET /places/name.xml
	def show
		@parking_place_info = Hash.new
		
		client = setup_savon
		message = {
			client_request: {
				password: ENV['AK_SOAP_PASS'],
				client_request_handle: 'ucn',
				request_time: DateTime::now
				},
				park_place_name: params[:id]
			}
		response = client.call(:park_places_info, message: message)

		if response.success?
			@parking_place_info = response.body[:park_places_info_response]
			@parking_place_info.delete(:'@xmlns:ns1') # Remove illegal key for XML rendering
		end

		respond_to do |format|
			format.html
			format.json { render json:@parking_place_info }
			format.xml { render xml:@parking_place_info }
		end
	end

	private

	def fetch_parking_places
		logger.debug "Called fetch_parking_places"

		parking_places = Array.new

		client = setup_savon
		message = {
			password: ENV['AK_SOAP_PASS'],
			client_request_handle: 'ucn',
			request_time: DateTime::now
		}
		response = client.call(:park_places, message: message)

		if response.success?
			response_content = response.body[:park_places_response]
			names = response_content[:name]
			is_opens = response_content[:is_open]
			is_payment_actives = response_content[:is_payment_active]
			status_park_places = response_content[:status_park_place]
			longitudes = response_content[:longitude]
			latitudes = response_content[:latitude]
			max_counts = response_content[:max_count]
			free_counts = response_content[:free_count]

			names.each_with_index do |n, i|
				place = Hash.new
				place[:name] = n
				place[:is_open] = is_opens[i]
				place[:is_payment_active] = is_payment_actives[i]
				place[:status_park_place] = status_park_places[i]
				place[:longitude] = longitudes[i]
				place[:latitude] = latitudes[i]
				place[:max_count] = max_counts[i]
				place[:free_count] = free_counts[i]

				parking_places << place
			end
		end
		parking_places
	end

	def setup_savon
		wsdl_path = File.expand_path("../ParkService.wsdl", __FILE__)
		Savon.client do
			log false
			log_level :debug
			pretty_print_xml true
			wsdl wsdl_path
			endpoint "http://83.90.235.21:8080/ParkService/services/ParkService/"
			digest_auth ENV['AK_AUTH_USER'], ENV['AK_AUTH_PASS']
			convert_request_keys_to :camelcase
		end
	end

	def SOAPerror(error)
		logger.debug "ERROR: #{error.message}"
		respond_to do |format|
			format.html
			format.json { render json: [] }
			format.xml { render xml: [] }
		end
	end
end
