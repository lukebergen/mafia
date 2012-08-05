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

addMessage = (message) ->
  Meteor.call("addMessage", Session.get("currentGameId"), Session.get("clientId"), message, ->)

sendMessageClicked = ->
  addMessage($("#newMessageInput").val())
  $("#newMessageInput").val("")

root.Template.gameView.currentGame = root.currentGame

root.Template.gameView.events =
  "click #leaveGame": ->
    root.leaveGame()

  "keyup #newMessageInput": (event) ->
    if (event.keyCode == 13)
      sendMessageClicked()

  "click #sendMessage": ->
    sendMessageClicked()