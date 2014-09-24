Router.configure
  layoutTemplate: 'AppLayout'
  templateNameConverter: 'upperCamelCase'

Router.map ->
  @route 'stream',
    path: '/'
    template: 'ArticleStream'
    data: ->
      Meteor.call "articles", (err, teasers) ->
        Session.set("articleList", teasers)
  @route 'article',
    path: '/articles/:id'
    template: 'ArticlePage'
    data: ->
      Meteor.call "article", @params.id, (err, res) ->
        Session.set("articleHtml", res.data?.publication?.html)
