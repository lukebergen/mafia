Meteor.subscribe("games")

Game = new Meteor.Collection("games")

Session.set("clientId", uuid())

root.clientName = ->
  Session.get("clientName")

root.currentGame = ->
  Game.findOne({gameId: Session.get('currentGameId')})

root.joinGame = (gameId) ->
  Session.set("currentGameId", gameId)
  Meteor.call("joinGame", Session.get("clientId"), Session.get("currentGameId"))

root.leaveGame = ->
  leavingId = Session.get("currentGameId")
  Session.set("currentGameId", undefined)
  Meteor.call("leaveGame", Session.get("clientId"), leavingId)
