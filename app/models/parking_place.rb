class ParkingPlace
  # extend Savon::Model

  # client do
  #   wsdl.document = File.expand_path("../ParkService.wsdl", __FILE__)
  #   wsdl.endpoint = "http://83.90.235.21:8080/ParkService/services/ParkService/"
  #   http.auth.digest ENV['AK_AUTH_USER'], ENV['AK_AUTH_PASS']
  #   config.pretty_print_xml = true
  # end

  # Accessor methods
  # attr_accessor :name
  # attr_accessor :open?
  # attr_accessor :payment_active?
  # attr_accessor :status_park_place
  # attr_accessor :longitude
  # attr_accessor :latitude
  # attr_accessor :max_count
  # attr_accessor :free_count

  # Requests
  def self.all
    response = client.request(:park_places) do
      soap.body = {
        password: ENV['AK_SOAP_PASS'],
        'ClientRequestHandle' => 'ucn',
        'RequestTime' => DateTime.now,
        :order! => ['Password', 'ClientRequestHandle', 'RequestTime']
      }
    end

    parking_places = []
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
    "#{@name} #{@free_count}/#{@max_count}"
  end

  def to_xml
    hash = {}
    hash[:name] = name
    hash[:is_open] = is_open
    hash.to_xml
  end
end
