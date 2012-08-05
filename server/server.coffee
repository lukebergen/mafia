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
    Game.update({'players.id': clientId}, {$set: {'players.$.lastBeat': new Date()}}, true, true)

Meteor.startup ->
  _.each ['games'], (collection) ->
    _.each ['insert', 'update', 'remove'], (method) ->
      Meteor.default_server.method_handlers['/' + collection + '/' + method] = ->

disconnectDeadClients = ->
  Fiber ->
    Game.update({}, {$pull: {players: {lastBeat: {$lt: (new Date((new Date()).getTime() - 6000)) }}}}, true, true)
  .run()

setInterval disconnectDeadClients, 6000
