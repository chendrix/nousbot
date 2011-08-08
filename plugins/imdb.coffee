Plugin = require '../lib/plugin'

info =
  name: 'imdb'
  trigger: 'imdb'
  doc: "'#{nous.config.leader}imdb <title> <year|optional>' finds the imdb data for the requested title and optional year"
  
imdb = (env) ->
  match = @matchTrigger env
  if match?
    splitMatch = match.split " "
    potentialYear = splitMatch[splitMatch.length - 1]
    year = ""
    
    # If the message matches a 4 digit year on the end, make that the year and the message
    # query is the rest of the message
    if potentialYear.match /^d{4}$/ 
      year = potentialYear 
      splitMatch.pop()
      match = splitMatch.join " "
      
    url = """
          http://www.imdbapi.com/?r=JSON
          &t=#{encodeURIComponent match}
          &y=#{encodeURIComponent year}
          """
    urlecho = "http://www.imdb.com/find?s=all&q=#{encodeURIComponent match}"
    
    url = url.replace /(\r\n|\n|\r)/gm,"" # stupid heredoc.... remove newlines
    
    @scrape url, (err, $, data) =>
      if err
        results = "Sorry, there was an error scraping the API, but you can try visiting #{urlecho}"
      else
        response = JSON.parse data if data
        if response.Response is "True"
          imdburl = "http://www.imdb.com/title/#{response.ID}"
          results = "#{response.Title} (#{response.Year}) (#{response.Genre}), Rated #{response.Rated}: #{response.Plot} - #{imdburl}"
        else if response.Response is "Movie Not Found"
          results = "Sorry, that movie could not be found, but you can try visiting #{urlecho}"
        else
          results = "Sorry, there was an error scraping the API, but you can try visiting #{urlecho}"
      @respond env, results    

module.exports = 
 imdb: new Plugin info, imdb


