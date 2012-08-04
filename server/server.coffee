Game = new Meteor.Collection("games")

Meteor.publish "games", ->
  Game.find {}, fields:
    gameId: true
    name: true
    creator: true
    created_at: true
    startTime: true
    endTime: true
    result: true
    players: true

Meteor.methods
  newGame: (name, clientId) ->
    new_game = game_doc()
    new_game.name = name
    new_game.creator = clientId
    Game.insert(new_game)
    new_game.gameId

  deleteAllGames: ->
    Game.remove({})
    "success"

  changeName: (id, new_name) ->
    Game.update({gameId: id}, {$set: {name: new_name}})

  joinGame: (clientId, gameId) ->
    Game.update({gameId: gameId}, {$push: {players: {id: clientId, lastBeat: new Date()}}})

  leaveGame: (clientId, gameId) ->
    console.log("#{clientId} is leaving game #{gameId}")
    Game.update({gameId: gameId}, {$pull: {players: {id: clientId}}})

  heartBeat: (clientId, gameId) ->
    "updated"

Meteor.startup ->
  _.each ['games'], (collection) ->
    _.each ['insert', 'update', 'remove'], (method) ->
      Meteor.default_server.method_handlers['/' + collection + '/' + method] = ->

disconnectOldClients = ->
  console.log("doing it")
  #Game.find({players: 10})

setInterval disconnectOldClients, 6000
