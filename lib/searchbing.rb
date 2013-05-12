require 'json'
require 'open-uri'
require 'net/http'


# The Bing Class provides the ability to connect to the bing search api hosted on the windows azure marketplace.
# Before proceeding you will need an account key, which can be obtained by registering an accout at http://windows.microsoft.com/en-US/windows-live/sign-in-what-is-microsoft-account
class Bing
	# Create a new object of the bing class
	#   >> animals = Bing.new('your_account_key_goes_here', 10, 'Image') 
	#   => #<Bing:0x9d9b9f4 @account_key="your_account_key", @num_results=10, @type="Image">
	# Arguments:
	#   account_key: (String)
	#   num_results: (Integer)
	#   type: 	   (String)

	def initialize(account_key, num_results, type)

		@account_key = account_key
		@num_results = num_results
		@type = type


	end

	attr_accessor :account_key, :num_results, :type, :thumbnail

	# Search for a term
	#   >> animals.search("lion") 
	#   => "{\"d\":{\"results\":[{\"__metadata\":{\"uri\":\"https://api.datamarket....
	# Arguments:
	#   search_term: (String)

	def search(search_term)
		 
		user = ''
		web_search_url = "https://api.datamarket.azure.com/Bing/Search/#{type}?$format=json&Query="
		query_portion = URI.encode_www_form_component('\'' + search_term + '\'')
		params = "&$top=#{@num_results}"
		full_address = web_search_url + query_portion + params

		uri = URI(full_address)
		req = Net::HTTP::Get.new(uri.request_uri)
		req.basic_auth user, account_key

		res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https'){|http|
  			http.request(req)
		}

		# general parsing structure
		# $jsonobj->d->results as $value
		# link $value->MediaURL
		# image $value->Thumbnail->MediaUrl

		body = JSON.parse(res.body)
		result_set = body["d"]["results"]	
	end	
end

animals = Bing.new('MM6OD0qjozdOWWvspc0j4DRkn4JEBM0A/cEQFHDKTYo', 2, 'Image')
p bing_results = animals.search("lion")
# returns an array of hashes with the results



=begin


# p result_set
		puts result_set[0]["MediaUrl"] # fullsize
		p result_set[0]["Thumbnail"]["MediaUrl"] #thumbnail
		p result_set[0]

		if (@type == "Image")
			puts "you got yourself an image"
			@thumbnail = result_set[0]["Thumbnail"]["MediaUrl"]
		end
=end



