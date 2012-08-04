root.leaveGame = ->
  leavingId = Session.get("currentGameId")
  Session.set("currentGameId", undefined)
  Meteor.call("leaveGame", Session.get("clientId"), leavingId)

root.Template.gameView.gameName = ->
  if (Session.get("currentGameId") != undefined)
    return Game.findOne({gameId: Session.get("currentGameId")}).name
  else
    return ""

root.Template.gameView.currentGame = root.currentGame

root.Template.gameView.events =
  "click #leaveGame": ->
    root.leaveGame()
