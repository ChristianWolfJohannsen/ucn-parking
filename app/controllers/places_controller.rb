class PlacesController < ApplicationController
	# GET places
	# GET places.json
	# GET places.xml
	def index
		client = setup_savon
		response = client.request(:park_places) {
			soap.body = {
				"Password" => ENV['AK_SOAP_PASS'],
				"RequestTime" => DateTime::now,
				"ClientRequestHandle" => 'ucn',
				:order! => ["Password", "ClientRequestHandle", "RequestTime"]
			}
		}

		@parking_places = Array.new
		if response.http.code == 200
			response_content = response[:park_places_response]
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
		response = client.request :park_places_info,
			body: {
				"ClientRequest" => {
					"Password" => ENV['AK_SOAP_PASS'],
					"ClientRequestHandle" => 'ucn',
					"RequestTime" => DateTime::now
					},
				"ParkPlaceName" => params[:id]
			}

		@parking_place_info = Hash.new
		if response.http.code == 200
			@parking_place_info = response[:park_places_info_response]
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
		Savon.configure do |config|
		  # By default, Savon logs each SOAP request and response to $stdout.
		  # Here's how you can disable logging:
		  config.log = false
		  config.pretty_print_xml = true
		end

		wsdl_path = File.expand_path("../ParkService.wsdl", __FILE__)
		Savon::Client.new do
			wsdl.document = wsdl_path
			wsdl.endpoint = "http://83.90.235.21:8080/ParkService/services/ParkService/"
			http.auth.digest ENV['AK_AUTH_USER'], ENV['AK_AUTH_PASS']
		end
	end
end
