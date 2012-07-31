Meteor.subscribe("games")

Games = new Meteor.Collection("games")

Session.set("clientId", uuid())

root.getName = ->
  Session.set("clientName", prompt("Name?"))

root.clientName = ->
  Session.get("clientName")

root.Template.nav.events =
  "click #deleteGames": ->
    Meteor.call("deleteAllGames")

root.Template.getName.events = 
  "click #clientSetName": ->
    Session.set("clientName", $("#clientSetName").val())
    $("#clientSetName").val("")

root.Template.gamesView.activeGames = ->
  Games.find({})

root.Template.gameItem.events =
  "click #joinGame": ->
    joinGame(this.gameId)

root.Template.gamesView.currentGame = root.Template.gameView.currentGame = ->
  Games.findOne({gameId: Session.get('currentGameId')})

root.Template.gamesView.events = 
  "click #newGameButton": ->
    n = prompt("name?")
    gameId = Meteor.call("newGame", n, Session.get("clientId"))
    joinGame(gameId)

root.Template.gameView.events =
  "click #leaveGame": ->
    leaveGame()

root.Template.gameView.gameName = ->
  if (Session.get("currentGameId") != undefined)
    return Games.findOne({gameId: Session.get("currentGameId")}).name
  else
    return ""