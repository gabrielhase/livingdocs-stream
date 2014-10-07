Future = Npm.require('fibers/future')

designMap =
  timeline:
    titles: [
      identifier: 'hero'
      contentField: 'title'
    ,
      identifier: 'head'
      contentField: 'title'
    ,
      identifier: 'title'
      contentField: 'title'
    ]
    images: [
      identifier: 'hero'
      contentField: 'image'
    ,
      identifier: 'fullsize'
      contentField: 'image'
    ,
      identifier: 'normal'
      contentField: 'image'
    ,
      identifier: 'peephole'
      contentField: 'image'
    ]
  morpheus:
    titles: [
      identifier: 'title'
      contentField: 'title'
    ,
      identifier: 'subtitle'
      contentField: 'title'
    ]
    images: [
      identifier: 'image'
      contentField: 'image'
    ]


# Handling of async code:
# - http://stackoverflow.com/questions/24743402/how-to-get-an-async-data-in-a-function-with-meteor
# - https://www.eventedmind.com/feed/meteor-what-is-meteor-bindenvironment

deduceTitleFromData = (content, designName) ->
  for snippet in content
    for target in designMap[designName].titles
      if snippet.identifier == "#{designName}.#{target.identifier}" && snippet.content[target.contentField]?
        return snippet.content[target.contentField]


deduceTeaserImageFromData = (content, designName) ->
  for snippet in content
    for target in designMap[designName].images
      return snippet.content[target.contentField] if snippet.identifier == "#{designName}.#{target.identifier}" && snippet.content[target.contentField]?


constructTeasers = (publications) ->
  teasers = []
  for publication in publications
    # the title
    title = publication.metadata.title if publication.metadata?.title
    title ?= deduceTitleFromData(publication.data.content, publication.data.design.name)
    # the teaser image
    teaserImage = publication.metadata.teaser_image if publication.metadata?.teaser_image
    teaserImage ?= deduceTeaserImageFromData(publication.data.content, publication.data.design.name)
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
