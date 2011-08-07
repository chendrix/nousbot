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
    
    if potentialYear.match /^d{4}$/ 
      year = potentialYear 
      splitMatch.pop()
      match = splitMatch.join " "
      
    url = """
          http://http://www.imdbapi.com/?r=JSON
          &t=#{encodeURIComponent match}
          &y=#{encodeURIComponent year}
          """
    urlecho = "http://www.imdb.com/find?s=all&q=#{encodeURIComponent match}"
    
    url = url.replace /(\r\n|\n|\r)/gm,"" # stupid heredoc.... remove newlines
    
    @scrape url, (err, $, data) =>
      if err
        @say env, "Sorry, there was an error scraping the API, but you can try visiting #{urlecho}"
      else
        response = @xml data if data
        if response?['@']?.success is 'true'
          if response?.pod?.subpod?.plaintext?
            calculation = response.pod.subpod.plaintext 
            @say env, "#{env.from}: #{calculation}"
          else
            @say env, "Sorry, couldn't calculate '#{match}' in plaintext, but you can visit #{urlecho}"
        else
          @say env, "Sorry, that query failed, but you can try visiting #{urlecho}"

if nous?.config?.apikeys?.wolframalpha?
    module.exports = {
        wolframalpha: new Plugin info, wa
    }
else
    console.log "No apikey set for wolframalpha, not enabling wolframalpha plugin."      
