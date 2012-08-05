
root.Template.nav.getName = ->
  Session.get("clientName")

root.Template.nav.events =
  "click #deleteGames": ->
    Meteor.call("deleteAllGames")

  "click #newGameButton": ->
    n = prompt("name?")
    gameId = Meteor.call("newGame", n, Session.get("clientId"))
    joinGame(gameId)

  "click #nameSetButton": ->
    Session.set("clientName", $("#clientSetName").val())
    Meteor.call("setClientName", Session.get("clientId"), Session.get("clientName"))
