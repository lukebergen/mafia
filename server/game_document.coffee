game_doc = ->
  return {
    gameId: uuid()
    name: ""
    creator: undefined
    created_at: new Date()
    startTime: undefined
    endTime: undefined
    result: undefined
    players: []
    publicChat: []
    #mafiaChat: []
    gamePeriods: []
  }
