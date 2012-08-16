Meteor.subscribe("games")

Game = new Meteor.Collection("games")

Session.set("clientId", uuid())

root.randomNames = ["Bob", "Cindy", "Carl", "Jane", "Durp"]

Session.set("clientName", root.randomNames[Math.round(Math.random() * root.randomNames.length)])

root.gameStatus = (game) ->
  if (game.startTime == null)
    return "Waiting for players"
  else if (game.endTime == null)
    return "In Progress"
  else
    return "Finished"

root.currentPlayer = ->
  Game.findOne({gameId: Session.get("currentGameId")}).players.filter ((p) ->
    p.clientId == Session.get("clientId")
  )[0]

root.heartBeat = ->
  Meteor.call("heartBeat", Session.get("clientId"), Session.get("currentGameId"))

root.setInterval root.heartBeat, 5000

root.clientName = ->
  Session.get("clientName")

root.currentGame = ->
  Game.findOne({gameId: Session.get('currentGameId')})

root.joinGame = (gameId) ->
  Session.set("currentGameId", gameId)
  Meteor.call("joinGame", Session.get("clientId"), Session.get("clientName"), Session.get("currentGameId"))

Meteor.methods
  addMessage: (gameId, clientId, message) ->
    name = Session.get("clientName")
    name = if name then "#{name}: " else ""
    $("#publicChat ul").append("<li>#{name}#{message}</li>")
    dv = $("#publicChat")
    root.lastScrollTop ?= dv.scrollTop()
    if (dv.scrollTop() >= root.lastScrollTop)
      dv.scrollTop(999999999)
      root.lastScrollTop = dv.scrollTop()
    ""
