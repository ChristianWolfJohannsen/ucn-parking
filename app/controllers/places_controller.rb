class PlacesController < ApplicationController
	# GET places
	# GET places.json
	# GET places.xml
	def index
		client = setup_savon
		message = {
			"Password" => ENV['AK_SOAP_PASS'],
			"RequestTime" => DateTime::now,
			"ClientRequestHandle" => 'ucn',
			:order! => ["Password", "ClientRequestHandle", "RequestTime"]
		}
		response = client.call(:park_places, message: message)

		@parking_places = Array.new
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

				@parking_places << place
			end
		end

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
		client = setup_savon
		message = {
			"ClientRequest" => {
				"Password" => ENV['AK_SOAP_PASS'],
				"ClientRequestHandle" => 'ucn',
				"RequestTime" => DateTime::now
			},
			"ParkPlaceName" => params[:id]
		}
		response = client.call(:park_places_info, message: message)

		@parking_place_info = Hash.new
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

	def setup_savon
		wsdl_path = File.expand_path("../ParkService.wsdl", __FILE__)
		Savon.client do
			log false
			logger Rails.logger
			pretty_print_xml true
			wsdl wsdl_path
			endpoint "http://83.90.235.21:8080/ParkService/services/ParkService/"
			digest_auth ENV['AK_AUTH_USER'], ENV['AK_AUTH_PASS']
		end
	end
end
