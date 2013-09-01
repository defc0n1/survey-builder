if (Meteor.isClient)
  console.log("yay I'm loaded")
  Pages = new Meteor.Collection("pages")
  SurveyFields = new Meteor.Collection("fields")

  # mainSurvey
  Template.mainSurvey.surveyPages = ->
    Pages.find({}, sort: {page: 1})

  # surveyPage
  Template.surveyPage.surveyFields = ->
    SurveyFields.find({page_id: "" + @_id}).fetch()

  Template.surveyPage.helpers
    displayField: ->
      Template[@template](@)


  ### FIELD TYPES ###
  events = {
    'dblclick': (e) ->
      Session.set('selectedFieldId', @_id)

    'change .required-check': (e) ->
      console.log(e)
      if e.target.checked
        SurveyFields.update(@_id, {$set: {required: true}})
      else
        SurveyFields.update(@_id, {$set: {required: false}})

    'click .done': (e) ->
      Session.set('selectedFieldId', "")
  }

  helpers = {
    isFocused: ->
      Session.get('selectedFieldId') == @_id
  }

  Template.shortInput.rendered = ->
    $( ".question" ).parent().sortable({
      axis: "y"
      revert: true
      placeholder: "sortable-placeholder"
      forcePlaceholderSize: true
      containment: ".main"
    })
    # $( ".question" ).parent().disableSelection()
    $( ".survey-header" ).parent().parent().sortable({ disabled: true })

  # shortInput
  Template.shortInput.events(_.extend({
    'blur .questionTitle': (e) ->
      SurveyFields.update(@_id, {$set: {title: e.target.value}})
    'blur .questionHelpText': (e) ->
      SurveyFields.update(@_id, {$set: {description: e.target.value}})

  }, events))
  Template.shortInput.helpers(_.extend({}, helpers))

  # surveyHeader
  Template.surveyHeader.events(_.extend({}, events))
  Template.surveyHeader.helpers(_.extend({}, helpers))

  # fieldTools
  Template.fieldTools.events({
    'click .edit': (e) ->
      Session.set('selectedFieldId', @_id)

    'click .copy': (e) ->
      copy = {}
      _(@).each((value, key) ->
        unless key == "_id"
          copy[key] = value
      )
      copyId = SurveyFields.insert(copy)
      Session.set('selectedFieldId', copyId )

    'click .delete': (e) ->
      SurveyFields.remove(@_id)
  })

  Template.fieldTools.rendered = ->
    $(".edit").tooltip()
    $(".copy").tooltip()
    $(".delete").tooltip()


