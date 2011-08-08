Plugin = require "../lib/plugin"

info =
    name: "google"
    trigger: ["google", "g"]
    doc: "'google <query>' -- returns a result for the given query"

googleurl = (service, query) ->
    query = encodeURIComponent query
    "http://ajax.googleapis.com/ajax/services/search/#{service}?v=1.0&safe=off&q=#{query}"


google = (env) ->
    query = @matchTrigger env
    if query?
        url = googleurl "web", query
        @scrape url, (err, $, data) =>
            response = JSON.parse data
            if response?.responseData?.results[0]?
                result = response.responseData.results[0]
                {titleNoFormatting, content, unescapedUrl} = result
                content = @cleanHTML content
                results = "#{unescapedUrl} - #{titleNoFormatting} -- #{content}"
            else
                results = "No results found for #{query}."
            @respond env, results

gisinfo =
    name: "google-images"
    trigger: ["gis", "image"]
    doc: "'google image <query>' -- returns a link to the first google images result for the given query"

googleimages = (env) ->
    query = @matchTrigger env
    if query?
        url = googleurl "images", query
        @scrape url, (err, $, data) =>
            response = JSON.parse data
            if response?.responseData?.results[0]?
                result = response.responseData.results[0]
                {titleNoFormatting, content, unescapedUrl} = result
                content = @cleanHTML content
                results = "#{unescapedUrl} -- #{content}"
            else
                results = "No results found for #{query}."
            @respond env, results

module.exports = {
    google: new Plugin info, google
    googleimages: new Plugin gisinfo, googleimages
}
