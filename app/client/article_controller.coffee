class @ArticleController extends RouteController


  show: ->
    @render 'Article',
      data: ->
        article = Articles.find({_id: @params._id}).fetch()[0]
        article: article


  index: ->
    @render 'ArticleStream',
      data: ->
        publicationId: Number(@params._id)
        articles: Articles.find(
          space_id: Number(@params._id),
          {sort: {created_at: -1}}
        ).fetch()
