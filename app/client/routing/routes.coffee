_this = @

Router.configure
  templateNameConverter: 'upperCamelCase'
  layoutTemplate: 'AppLayout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: ->
    Meteor.subscribe('articles', 1)


Router.route '/', ->
  window.location = 'http://www.livingdocs.io'


Router.route '/publications/:_id',
  controller: 'ArticleController'
  action: 'index'
  name: 'listArticles'


Router.route '/publications/:space_id/articles/:_id',
  controller: 'ArticleController'
  action: 'show'
  name: 'showArticle'
