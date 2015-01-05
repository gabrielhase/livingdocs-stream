_this = @

Router.configure
  templateNameConverter: 'upperCamelCase'
  layoutTemplate: 'AppLayout'

Router.onBeforeAction('loading')

Router.map ->
  @route 'publication',
    path: '/publications/:id'
    waitOn: ->
      Meteor.subscribe('articles')
    template: 'ArticleStream'
    controller: 'ArticleController'
    action: 'index'
  @route 'article',
    waitOn: ->
      Meteor.subscribe('article', @params.id)
    path: '/publications/:space_id/articles/:id'
    controller: 'ArticleController'
    action: 'show'


Router.route '/', ->
  window.location = 'http://www.livingdocs.io'
