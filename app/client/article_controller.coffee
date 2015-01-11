_this = @

class @ArticleController extends RouteController


  show: ->
    if @ready()
      # we set this in the session since the rendering happens in
      # the rendered callback of the Article template.
      Session.set('articleId', @params._id)
      @render('Article')
    else
      console.log 'loading'


  index: ->
    @render 'ArticleStream',
      data: ->
        publicationId: Number(@params._id)
        articles: Articles.find(
          space_id: Number(@params._id),
          {sort: {created_at: -1}}
        ).fetch()
