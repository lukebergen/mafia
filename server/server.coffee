Games = new Meteor.Collection("games")

Meteor.publish "games", ->
  Games.find {}, fields:
    gameId: true
    name: true
    creator: true
    created_at: true
    start_time: true
    end_time: true
    result: true
    players: true

Meteor.methods
  newGame: (name, client_id) ->
    new_game = game_doc()
    new_game.name = name
    new_game.creator = client_id
    Games.insert(new_game)
    new_game.gameId
  deleteAllGames: ->
    Games.remove({})
    "success"
  changeName: (id, new_name) ->
    Games.update({gameId: id}, {$set: {name: new_name}})
  putsIt: ->
    console.log("game count: #{Games.find({}).count()}")


Meteor.startup ->
  _.each ['games'], (collection) ->
    _.each ['insert', 'update', 'remove'], (method) ->
      Meteor.default_server.method_handlers['/' + collection + '/' + method] = ->
