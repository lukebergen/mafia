root.Template.gameList.activeGames = ->
  Game.find({})

root.Template.gameItem.status = ->
  root.gameStatus(this)

root.Template.gameItem.events =
  "click #joinGame": ->
    joinGame(this.gameId)

root.Template.gameList.currentGame = root.currentGame
