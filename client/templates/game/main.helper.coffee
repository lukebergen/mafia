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

root.Template.playerList.playerNames = ->
  Game.findOne(gameId: Session.get("currentGameId")).players.map (p) ->
    p.name

addMessage = (message) ->
  Meteor.call("addMessage", Session.get("currentGameId"), Session.get("clientId"), message, ->)

sendMessageClicked = ->
  addMessage($("#newMessageInput").val())
  $("#newMessageInput").val("")

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