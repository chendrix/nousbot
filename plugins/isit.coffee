module.exports = (app) ->
    {command, parse} = app.util
    
    isit = (nous) ->
        command nous, "isit", (input) ->
            switch input.msg
                when "monday"
                    url = "http://isitmondaynow.com/"
                    selector = "h2"
                when "halloween"
                    url = "http://isithalloween.com/"
                    selector = "h1"
                when "friday"
                    url = "http://isitfriday.biz/"
                    selector = "#yesOrNo"
                else
                    url = "http://isitchristmas.com/"
                    selector = "#answer"

            parse url, (err, $, data) ->
                quote = $(selector)?.text || "Sorry, I have no idea"
                nous.say input.to, quote

    return {
        start: isit
    }
