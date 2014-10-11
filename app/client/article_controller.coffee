_this = @

@ArticleController = RouteController.extend

  layoutTemplate: 'AppLayout'

  show: ->
    if @ready()
      Session.set('articleId', @params.id)
      @render('Article')
    else
      console.log 'loading'


  index: ->
    @render('ArticleStream')
