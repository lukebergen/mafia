Games = new Meteor.Collection("games")

Meteor.publish "games", ->
  Games.find {}, fields:
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
    Games.insert(new_game)
    new_game.gameId

  deleteAllGames: ->
    Games.remove({})
    "success"

  changeName: (id, new_name) ->
    Games.update({gameId: id}, {$set: {name: new_name}})

  joinGame: (clientId, gameId) ->
    Games.update({gameId: gameId}, {$push: {players: clientId}})

  leaveGame: (clientId, gameId) ->
    game = Games.findOne({gameId: gameId})
    Games.update({gameId: game.gameId}, $pull: {players: clientId})

Meteor.startup ->
  _.each ['games'], (collection) ->
    _.each ['insert', 'update', 'remove'], (method) ->
      Meteor.default_server.method_handlers['/' + collection + '/' + method] = ->
