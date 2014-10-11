_this = @

Router.configure
  templateNameConverter: 'upperCamelCase'

Router.onBeforeAction('loading')

Router.map ->
  @route 'stream',
    waitOn: ->
      Meteor.subscribe('articles')
    path: '/'
    template: 'ArticleStream'
    controller: 'ArticleController'
    action: 'index'
  @route 'article',
    waitOn: ->
      Meteor.subscribe('articles')
    path: '/articles/:id'
    template: 'ArticlePage'
    controller: 'ArticleController'
    action: 'show'
