_this = @

Router.configure
  templateNameConverter: 'upperCamelCase'
  layoutTemplate: 'AppLayout'

Router.onBeforeAction('loading')

Router.map ->
  @route 'stream',
    path: '/'
    waitOn: ->
      Meteor.subscribe('articles')
    template: 'ArticleStream'
  @route 'article',
    waitOn: ->
      Meteor.subscribe('article', @params.id)
    path: '/articles/:id'
    controller: 'ArticleController'
    action: 'show'
