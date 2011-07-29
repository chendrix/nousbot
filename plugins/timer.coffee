Plugin = require "../lib/plugin"

info =
  name: "wait"
  trigger: "timer"

# ideally this should parse #d#h#m#s and be able to take a mesage in as well

wait = (env) ->
    # Check the env for a remainder after a trigger
    match = @matchTrigger env
    # If we find it, say it back to the environment
    if match?
        setTimeout (=> @respond env, "DING DING DING"), match

# export our new plugin
module.exports =
    wait: new Plugin info, wait
