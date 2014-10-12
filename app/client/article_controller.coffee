_this = @

class @ArticleController extends RouteController


  show: ->
    if @ready()
      Session.set('articleId', @params.id)
      @render('Article')
    else
      console.log 'loading'
