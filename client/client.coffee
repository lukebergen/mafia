Meteor.subscribe("games")

Game = new Meteor.Collection("games")

Session.set("clientId", uuid())

root.heartBeat = ->
  Meteor.call("heartBeat", Session.get("clientId"), Session.get("currentGameId"))

root.setInterval root.heartBeat, 5000

root.clientName = ->
  Session.get("clientName")

root.currentGame = ->
  Game.findOne({gameId: Session.get('currentGameId')})

root.joinGame = (gameId) ->
  Session.set("currentGameId", gameId)
  Meteor.call("joinGame", Session.get("clientId"), Session.get("currentGameId"))
