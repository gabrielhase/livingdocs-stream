_this = @

class @ArticleController extends RouteController


  show: ->
    if @ready()
      # we set this in the session since the rendering happens in
      # the rendered callback of the Article template.
      Session.set('articleId', @params.id)
      @render('Article')
    else
      console.log 'loading'


  index: ->
    if @ready()
      @render 'ArticleStream',
        data: ->
          publicationId: +@params.id
          articles: Articles.find(
            space_id: +@params.id,
            {sort: {created_at: -1}}
          ).fetch()
    else
      console.log 'loading'
