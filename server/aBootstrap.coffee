root.assignRoles = (game) ->
  mafia = []
  players = game.players
  for [1 .. Math.floor(players.length / 4)]
    mafia.push(players.splice(Math.round(Math.random() * players.length), 1)[0].clientId)

  doctor = players.splice(Math.round(Math.random() * players.length), 1)[0].clientId
  cop = players.splice(Math.round(Math.random() * players.length), 1)[0].clientId
  
  Game.update({gameId: game.gameId, "players.clientId": {$in: mafia}}, {"players.$.role": "mafia"})
  Game.update({gameId: game.gameId, "players.clientId": doctor}, {"players.$.role": "doctor"})
  Game.update({gameId: game.gameId, "players.clientId": cop}, {"players.$.role": "cop"})
