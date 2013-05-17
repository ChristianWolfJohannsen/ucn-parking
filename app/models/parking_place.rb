class ParkingPlace
	# extend Savon::Model

	# client do
	# 	wsdl.document = File.expand_path("../ParkService.wsdl", __FILE__)
	# 	wsdl.endpoint = "http://83.90.235.21:8080/ParkService/services/ParkService/"
	# 	http.auth.digest ENV['AK_AUTH_USER'], ENV['AK_AUTH_PASS']
	# 	config.pretty_print_xml = true
	# end

	# Accessor methods
	def name
		@name
	end

	def name=(value)
		@name = value
	end

	def is_open
		@is_open
	end

	def is_open=(value)
		@is_open = value
	end

	def is_payment_active
		@is_payment_active
	end

	def is_payment_active=(value)
		@is_payment_active = value
	end

	def status_park_place
		@status_park_place
	end

	def status_park_place=(value)
		@status_park_place = value
	end

	def longitude
		@longitude
	end

	def longitude=(value)
		@longitude = value
	end

	def latitude
		@latitude
	end

	def latitude=(value)
		@latitude = latitude
	end

	def max_count
		@max_count
	end

	def max_count=(value)
		@max_count = value
	end

	def free_count
		@free_count
	end

	def free_count=(value)
		@free_count = value
	end

	# Requests
	def self.all
		response = client.request(:park_places) {
			soap.body = {
				"Password" => ENV['AK_SOAP_PASS'],
				"ClientRequestHandle" => 'ucn',
				"RequestTime" => DateTime::now,
				:order! => ["Password", "ClientRequestHandle", "RequestTime"]
			}
		}

		parking_places = Array.new
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
				place = ParkingPlace.new
				place.name = n
				place.is_open = is_opens[i]
				place.is_payment_active = is_payment_actives[i]
				place.status_park_place = status_park_places[i]
				place.longitude = longitudes[i]
				place.latitude = latitudes[i]
				place.max_count = max_counts[i]
				place.free_count = free_counts[i]

				parking_places << place
			end
		end
		parking_places
	end

	def to_s
		"#@name #{@free_count}/#{@max_count}"
	end

	def to_xml
		hash = {}
		hash[:name] = name
		hash[:is_open] = is_open
		hash.to_xml
	end
end
