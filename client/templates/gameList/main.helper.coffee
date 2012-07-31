root.Template.gameList.activeGames = ->
  Game.find({})

root.Template.gameList.events = 
  "click #newGameButton": ->
    n = prompt("name?")
    gameId = Meteor.call("newGame", n, Session.get("clientId"))
    joinGame(gameId)

root.Template.gameItem.events =
  "click #joinGame": ->
    joinGame(this.gameId)

root.Template.gameList.currentGame = root.currentGame
