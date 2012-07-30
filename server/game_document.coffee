game_doc = ->
  return {
    gameId: uuid()
    name: ""
    creator: undefined
    created_at: new Date()
    start_time: undefined
    end_time: undefined
    result: undefined
    players: {}
    public_chat: {}
    slasher_chat: {}
    game_periods: {}
  }

uuid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else (r & 0x3|0x8)
    v.toString(16)
  )
