root.Template.gameView.events =
  "click #leaveGame": ->
    leaveGame()

root.Template.gameView.gameName = ->
  if (Session.get("currentGameId") != undefined)
    return Game.findOne({gameId: Session.get("currentGameId")}).name
  else
    return ""

root.Template.gameView.currentGame = root.currentGame
