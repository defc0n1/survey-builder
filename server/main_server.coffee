if (Meteor.isServer)
  Pages = new Meteor.Collection("pages")
  SurveyFields = new Meteor.Collection("fields")

  Meteor.startup ->
    # seed database if needed
    if Pages.find().count() == 0
      pageId = Pages.insert({page: 1})

      SurveyFields.insert(
        page_id: pageId
        template: "surveyHeader"
        title: ""
        description: ""
        position: 1
      )

      SurveyFields.insert(
        page_id: pageId
        template: "shortInput"
        title: "What is your name?"
        description: "Please enter your full name..."
        position: 2
      )
