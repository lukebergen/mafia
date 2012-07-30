root = global ? window

uuid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else (r & 0x3|0x8)
    v.toString(16)

joinGame = (gameId) ->
  Session.set("currentGameId", gameId)
  Meteor.call("joinGame", clientId, Session.get("currentGameId"))

leaveGame = ->
  leavingId = Session.get("currentGameId")
  Session.set("currentGameId", undefined)
  Meteor.call("leaveGame", clientId, leavingId)

killPlayer = (clientId, gameId) ->
  Meteor.call("remove")