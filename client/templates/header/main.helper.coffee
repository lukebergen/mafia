
root.Template.name.getName = ->
  Session.get("clientName")

root.Template.nav.events =
  "click #deleteGames": ->
    Meteor.call("deleteAllGames")

root.Template.name.events = 
  "click #nameSetButton": ->
    Session.set("clientName", $("#clientSetName").val())
    Meteor.call("setClientName", Session.get("clientId"), Session.get("clientName"))
