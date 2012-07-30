root = global ? window

Meteor.subscribe("games")

Games = new Meteor.Collection("games")

client_id = uuid()

root.Template.nav.events =
  "click #deleteGames": ->
    Meteor.call("deleteAllGames")

root.Template.games_view.active_games = ->
  Games.find({})

root.Template.game_item.events =
  "click #joinGame": ->
    Session.set("currentGameId", this.gameId)
    Meteor.call("joinGame", client_id, Session.get("currentGameId"))

root.Template.games_view.events = 
  "click #newGameButton": ->
    n = prompt("name?")
    gameId = Meteor.call("newGame", n, client_id)
    Session.set("currentGameId", gameId)
    Meteor.call("joinGame", client_id, Session.get("currentGameId"))
