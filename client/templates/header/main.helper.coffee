root.Template.nav.events =
  "click #deleteGames": ->
    Meteor.call("deleteAllGames")

root.Template.name.events = 
  "click #nameSetButton": ->
    Session.set("clientName", $("#clientSetName").val())
    $("#clientSetName").val("")
