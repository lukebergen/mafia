Game = new Meteor.Collection("games")

Meteor.publish "games", ->
  Game.find({})
# Meteor.publish "games", ->
#   Game.find {}, fields:
#     gameId: true
#     name: true
#     creator: true
#     created_at: true
#     startTime: true
#     endTime: true
#     result: true
#     players: true

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

  joinGame: (clientId, clientName, gameId) ->
    Game.update({gameId: gameId}, {$push: {players: {id: clientId, name: clientName, lastBeat: new Date()}}})

  leaveGame: (clientId, gameId) ->
    console.log("#{clientId} is leaving game #{gameId}")
    Game.update({gameId: gameId}, {$pull: {players: {id: clientId}}})

  heartBeat: (clientId, gameId) ->
    Game.update({'players.id': clientId}, {$set: {'players.$.lastBeat': new Date()}}, true, true)

  addMessage: (gameId, clientId, message) ->
    #clientName = Game.findOne({gameId: gameId, "players.id": clientId})
    msg_obj = {name: "something", message: message}
    msg_obj.name = Game.findOne({gameId: gameId}).players.filter((p) ->
      p.id == clientId
    )[0]?.name
    console.log(msg_obj)
    Game.update({gameId: gameId}, {$push: {publicChat: msg_obj}})

  setClientName: (clientId, clientName) ->
    Game.update({"players.clientId": clientId}, {$set: {"players.$.name": clientName}}, true, true)

  startGame: (gameId) ->
    Game.update({gameId: gameId}, {$set: {startTime: new Date()}})
    console.log(Game.findOne(gameId: gameId))
    "success"

Meteor.startup ->
  _.each ['games'], (collection) ->
    _.each ['insert', 'update', 'remove'], (method) ->
      Meteor.default_server.method_handlers['/' + collection + '/' + method] = ->

disconnectDeadClients = ->
  Fiber ->
    Game.update({}, {$pull: {players: {lastBeat: {$lt: (new Date((new Date()).getTime() - 6000)) }}}}, true, true)
  .run()

setInterval disconnectDeadClients, 6000
