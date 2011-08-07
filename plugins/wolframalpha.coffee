Plugin = require '../lib/plugin'

info =
  name: 'wolframalpha'
  trigger: 'wa'
  doc: "'#{nous.config.leader}wa <calculation>' returns the response to submitting the <calculation> to wolfram alpha"
  
wa = (env) ->
  match = @matchTrigger env
  if match?
    url = """
          http://api.wolframalpha.com/v2/query?appid=#{nous.config.apikeys.wolframalpha}
          &input=#{encodeURIComponent match}
          &format=plaintext
          &includepodid=Result&includepodid=DecimalApproximation
          """
    urlecho = "http://www.wolframalpha.com/input/?i=#{encodeURIComponent match}"
    
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
