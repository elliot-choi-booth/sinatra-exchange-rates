# /app.rb

require "sinatra"
require "sinatra/reloader"
require "dotenv/load"

# Pull in the HTTP class
require "http"

# define a route for the homepage
get("/") do

  # Assemble the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATES_KEY")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  # Render a view template
  erb(:homepage)

  # In the view template, embed the @parsed_data variable to
  # see what you're working with.
  
  # From there, use your Hash/Array skills to make the homepage 
  # match the target.
  
  # Remember to Make The Invisible Visible — View Source in 
  # Chrome to see what your templates are actually outputting, 
  # and embed as many instance variables as you need to (this 
  # is the new equivalent of pretty-printing everything).
end

get("/:first_symbol") do
  @first_symbol = params.fetch("first_symbol")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATES_KEY")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  erb(:first_symbol)
  
  # Some more code to parse the URL and render a view template.
  # (HINT: this code is identical to the first route, you just
  # render a different view template at the end.)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  @api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATES_KEY").chomp}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  @raw_response = HTTP.get(@api_url)

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)

  @amount = @parsed_response.fetch("result")
  
  # Some more code to parse the URL and render a view template.
  erb(:step_two)
end
