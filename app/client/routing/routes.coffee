_this = @

Router.configure
  templateNameConverter: 'upperCamelCase'
  layoutTemplate: 'AppLayout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'


Router.route '/', ->
  window.location = 'http://www.livingdocs.io'


Router.route '/publications/:_id',
  controller: 'ArticleController'
  action: 'index'
  name: 'listArticles'
  waitOn: ->
    Meteor.subscribe('articles', @params._id)



Router.route '/publications/:space_id/articles/:_id',
  controller: 'ArticleController'
  action: 'show'
  name: 'showArticle'
  waitOn: ->
    Meteor.subscribe('articles', @params.space_id)
