require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'

# Index Page
# Our main view page
get '/' do
  File.read('views/index.html')
end

# Details Page :: /details/:imdb
# When "Details" is clicked on the index page of any movie, an iframe pops open to show details of the movie.
# The details page is made with embedded ruby for HTML styling and is passed the necessary parameters, in this case the imdbID of the movie.
# I decided to go with a different approach for the details page by using "open-uri" gem to web-scrape the necessary information
# After scraping all information and parsing through with the "json" gem's parse function, I passed the information to
# local varraibles for use in the "details.erb" file. I'm using embedded ruby for this to use the varraibles in
# the details view page with Bootstrap CSS to improve the view.
get '/details/:imdb' do
  id = params[:imdb]
  body = open("http://www.omdbapi.com/?i=#{id}&plot=full").read
  movieDetails = JSON.parse(body)

  erb :details, :locals => {
    :id => movieDetails["imdbID"],
    :title => movieDetails["Title"],
    :poster => movieDetails["Poster"],
    :year => movieDetails["Year"],
    :released => movieDetails["Released"],
    :runtime => movieDetails["Runtime"],
    :director => movieDetails["Director"],
    :actors => movieDetails["Actors"],
    :ratings => movieDetails["Metascore"],
    :plot => movieDetails["Plot"]
  }

end

# Add To Favorites :: /add/:imdb
# A quick page to add the movie's imdbID and title to "data.json"
# We'll be passing imdbID to OMDb API again later when viewing details of favorit movies
get '/add/:imdb' do
  id = params[:imdb]
  readJSON = open("http://www.omdbapi.com/?i=#{id}&plot=full").read
  movieDetails = JSON.parse(readJSON)

  addToFile = {
    id: movieDetails["imdbID"],
    title: movieDetails["Title"],
    year: movieDetails["Year"]
  }

  File.open("data.json","w") do |f|
   f.write(JSON.pretty_generate(addToFile))
  end

  "<h2>Added To Favorites</h2>"

end

# Favorites Page
# Show movies favorited by user
get '/favorites' do
  file = JSON.parse(File.read('data.json'))
  erb :favorites, :locals => {
    :id => file["id"],
    :title => file["title"],
    :year => file["year"]
  }
end
