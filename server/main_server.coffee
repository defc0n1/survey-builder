if (Meteor.isServer)
  Pages = new Meteor.Collection("pages")
  SurveyFields = new Meteor.Collection("fields")

  Meteor.startup ->
    # seed database if needed
    if Pages.find().count() == 0
      pageId = Pages.insert({page: 1})

      SurveyFields.insert(
        pageId: pageId
        template: "surveyHeader"
        title: ""
        description: ""
        position: 1
      )
