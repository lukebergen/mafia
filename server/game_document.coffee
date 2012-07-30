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
    slasherChat: []
    gamePeriods: []
  }

uuid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else (r & 0x3|0x8)
    v.toString(16)
  )
