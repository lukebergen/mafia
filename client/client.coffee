root = global ? window

root.Template.gameList.gameList = ->
  "a list of games"

root.Template.gameList.events = 
  "click #newGameButton": ->
    console.log "You pressed the button"
