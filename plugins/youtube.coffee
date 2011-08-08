Plugin = require "../lib/plugin"

info =
    name: "youtube"
    trigger: ["youtube", "y"]
    doc: "'#{nous.config.leader}<youtube|y> <query>' -- returns the first youtube result for the given query"

youtube = (env) ->
    query = @matchTrigger env
    
    if query?
      key = if nous?.config?.apikeys?.youtube? then "key=#{nous.config.apikeys.youtube}" else "" 
      url = """
            https://gdata.youtube.com/feeds/api/videos?#{key}
            &q=#{encodeURIComponent query}
            &orderby=relevance
            &max-results=1
            &v=2
            &alt=json
            """
      urlecho = "http://www.youtube.com/results?search_query=#{encodeURIComponent query}"
    
      url = url.replace /(\r\n|\n|\r)/gm,"" # stupid heredoc.... remove newlines
      
      @scrape url, (err, $, data) =>
        if err
          results ="Sorry, there was an error scraping the API, but you can try visiting #{urlecho}"
        else
          response = JSON.parse data
          if response?.feed?.entry?[0]?
              result = response.feed.entry[0]
              {title, link} = result
              results = "#{title.$t} -- #{link[0].href}"
          else
              results = "No results found for #{query}, but you can try visiting #{urlecho}"
              
        @respond env, results


if not nous?.config?.apikeys?.youtube?
  console.log "No apikey set for youtube; it's optional, but you should really get an API key."
  
module.exports = {
  youtube: new Plugin info, youtube
}
