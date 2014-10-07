Future = Npm.require('fibers/future')

#url = "http://localhost:9090/publications"


mockMeta =
  teaser_image: 'http://app.resrc.it/https://livingdocs-images-dev.s3.amazonaws.com/6a164594-7f6c-43fa-8977-1d1ed64a0120'
  title: 'Travelling to wonderland'
  caption: 'Have you ever wanted to follow in the steps of ...'

# Handling of async code:
# - http://stackoverflow.com/questions/24743402/how-to-get-an-async-data-in-a-function-with-meteor
# - https://www.eventedmind.com/feed/meteor-what-is-meteor-bindenvironment

deduceTitleFromData = (content) ->
  for snippet in content
    for type in ['hero', 'head', 'title']
      return snippet.content.title if snippet.identifier == "timeline.#{type}" && snippet.content.title?


deduceTeaserImageFromData = (content) ->
  for snippet in content
    for type in ['hero', 'fullsize', 'normal', 'peephole']
      return snippet.content.image if snippet.identifier == "timeline.#{type}" && snippet.content.image?


constructTeasers = (publications) ->
  teasers = []
  for publication in publications
    # the title
    title = publication.metadata.title if publication.metadata?.title
    title ?= deduceTitleFromData(publication.data.content)
    # the teaser image
    teaserImage = publication.metadata.teaser_image if publication.metadata?.teaser_image
    teaserImage ?= deduceTeaserImageFromData(publication.data.content)
    # the link target
    articleId = publication.document_id
    teasers.push {title, teaserImage, articleId}
    title = teaserImage = articleId = undefined
  teasers


Meteor.methods

  article: (id) ->
    #console.log "GETTING ARTICLE FROM API: #{Meteor.settings.apiUrl}"
    fut = new Future()
    handler = Meteor.bindEnvironment (err, res) ->
      #console.log res
      return fut.throw(new Error("Request error: #{err}")) if err
      fut.return(res)
    , (exception) ->
      fut.throw(new Error("Exception while getting documents"))

    Meteor.http.call("GET", "#{Meteor.settings.apiUrl}/public/#{id}", handler)

    fut.wait()


  articles: ->
    fut = new Future()
    handler = Meteor.bindEnvironment (err, res) ->
      return fut.throw(new Error("Request error: #{err}")) if err
      teasers = constructTeasers(res.data.publications)
      fut.return(teasers)
    , (exception) ->
      fut.throw(new Error("Exception while getting documents"))

    Meteor.http.call("GET", "#{Meteor.settings.apiUrl}/public", handler)

    fut.wait()
