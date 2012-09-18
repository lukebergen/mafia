root.leaveGame = ->
  leavingId = Session.get("currentGameId")
  Session.set("currentGameId", undefined)
  root.lastScrollTop = undefined
  Meteor.call("leaveGame", Session.get("clientId"), leavingId)

root.Template.gameView.gameName = ->
  if (Session.get("currentGameId") != undefined)
    return Game.findOne({gameId: Session.get("currentGameId")}).name
  else
    return ""

root.Template.gameView.gameStarted = ->
  Game.findOne({gameId: Session.get("currentGameId")}).startTime != null

root.Template.gameView.userRole = ->
  root.currentPlayer()?.role

root.Template.gameView.userIsMafia = ->
  root.currentPlayer()?.role == "Mafia"

root.Template.publicChatArea.publicMessages = ->
  Game.findOne({gameId: Session.get("currentGameId")}).publicChat

root.Template.publicChatArea.updatePublicChat = ->
  dv = $("#publicChat")
  root.lastScrollTop ?= dv.scrollTop()
  if (dv.scrollTop() >= root.lastScrollTop)
    dv.scrollTop(999999999)
    root.lastScrollTop = dv.scrollTop()
  ""

root.Template.publicChatArea.formatMessage = ->
  "#{this.name}: #{this.message}"

root.Template.mafiaChatArea.formatMessage = ->
  "#{this.name}: #{this.message}"

root.Template.mafiaChatArea.mafiaMessages = ->
  MafiaChat.findOne({gameId: Session.get("currentGameId")})?.messages

root.Template.playerList.playerNames = ->
  Game.findOne(gameId: Session.get("currentGameId")).players.map (p) ->
    p.name

sendMessageClicked = ->
  message = $("#newMessageInput").val()
  Meteor.call("addMessage", Session.get("currentGameId"), Session.get("clientId"), message, ->)
  $("#newMessageInput").val("")

sendMafiaMessageClicked = ->
  message = $("#newMafiaMessageInput").val()
  console.log("calling out to meteor to add mafia message: #{message}")
  Meteor.call("mafiaAddMessage", Session.get("currentGameId"), Session.get("clientId"), message, ->)
  $("#newMafiaMessageInput").val("")

root.Template.gameView.currentGame = root.currentGame

root.Template.gameView.events =
  "click #leaveGame": ->
    if (!root.Template.gameView.gameStarted() || confirm("The game is in progress. Leaving now means your character will die.  Continue?"))
      root.leaveGame()

  "click #startGame": ->
    if confirm("Are you sure? Once the game is started no more players will be able to join")
      Meteor.call "startGame", Session.get("currentGameId"), gameStarted

  "keyup #newMessageInput": (event) ->
    if (event.keyCode == 13)
      sendMessageClicked()

  "click #sendMessage": ->
    sendMessageClicked()

  "keyup #newMafiaMessageInput": (event) ->
    if (event.keyCode == 13)
      sendMafiaMessageClicked()

  "click #sendMafiaMessage": ->
    sendMafiaMessageClicked()
