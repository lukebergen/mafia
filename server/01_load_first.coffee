root.assignRoles = (game) ->
  mafia = []
  f = (p) ->
    p.clientId
  playerIds = _.map(game.players, f)
  for [1 .. Math.floor(playerIds.length / 4)]
    mafia.push(playerIds.splice(Math.round(Math.random() * playerIds.length), 1)[0])

  doctor = playerIds.splice(Math.round(Math.random() * playerIds.length), 1)[0]
  cop = playerIds.splice(Math.round(Math.random() * playerIds.length), 1)[0]

  mafia.forEach (x) ->
    Game.update({gameId: game.gameId, "players.clientId": x}, {$set: {"players.$.role": "Mafia"}})
  Game.update({gameId: game.gameId, "players.clientId": doctor}, {$set: {"players.$.role": "Doctor"}})
  Game.update({gameId: game.gameId, "players.clientId": cop}, {$set: {"players.$.role": "Cop"}})

  # and everybody else is a townsperson
  playerIds.forEach (x) ->
    Game.update({gameId: game.gameId, "players.clientId": x}, {$set: {"players.$.role": "Townsperson"}})

# some global variables
narratorName = "Narrator"