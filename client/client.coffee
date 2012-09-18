Meteor.subscribe("games")

Game = new Meteor.Collection("games")

Session.set("clientId", uuid())

# why does commenting this out cause problems.
# we want the player's role changing to cause mafiaChat to be subscribed to.
# Meteor.autosubscribe -> 
#   role = _.find(Game.findOne({gameId: Session.get("gameId")})?.players, root.currentPlayer()?.role)
#   clientId = Session.get("clientId")
#   gameId = Session.get("currentGame")
#   Meteor.subscribe("mafiaChat", gameId, clientId, role)

# why this publication no getting updated? :(
MafiaChat = new Meteor.Collection("mafiaChat")

root.randomNames = ["Agosto", "Alessandro", "Angelo", "Antonio", "Armando", "Carlo", "Dante", "Emilio", "Nico", "Piero", "Raffaele", "Rocco", "Valentino", "Alessandra", "Alisa", "Andria", "Belinda", "Belladonna", "Bianca", "Caprice", "Carmela", "Donata", "Isabella", "Loretta", "Mariabella", "Phebe", "Rosalia", "Rosetta", "Vivian"]

Session.set("clientName", root.randomNames[Math.round(Math.random() * root.randomNames.length)])

root.gameStatus = (game) ->
  if (game.startTime == null)
    return "Waiting for players"
  else if (game.endTime == null)
    return "In Progress"
  else
    return "Finished"

root.gameStarted = (errors, response) ->
  unless response == "success"
    alert(response)

root.currentPlayer = ->
  a = Game.findOne({gameId: Session.get("currentGameId")}).players.filter ((p) ->
    p.clientId == Session.get("clientId")
  )
  a[0]

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

  addMafiaMessage: (gameId, clientId, message) ->
    name = Session.get("clientName")
    name = if name then "#{name}: " else ""
    $("#mafiaChat ul").append("<li>#{name}#{message}</li>")
    dv = $("#mafiaChat")
    root.lastMafiaScrollTop ?= dv.scrollTop()
    if (dv.scrollTop() >= root.lastMafiaScrollTop)
      dv.scrollTop(999999999)
      root.lastMafiaScrollTop = dv.scrollTop()
    ""