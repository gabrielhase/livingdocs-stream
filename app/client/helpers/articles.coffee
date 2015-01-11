Template.ArticleStream.articles = ->
  teaserBuilder = new TeaserBuilder(@articles)
  teasers = teaserBuilder.getTeasers()
  teasers


