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

class @TeaserBuilder

  constructor: (articles) ->
    @articles = articles


  deduceTitleFromData: (content, designName) ->
    for snippet in content
      for target in designMap[designName].titles
        if snippet.identifier == "#{designName}.#{target.identifier}" && snippet.content[target.contentField]?
          return snippet.content[target.contentField]


  deduceTeaserImageFromData: (content, designName) ->
    for snippet in content
      for target in designMap[designName].images
        return snippet.content[target.contentField] if snippet.identifier == "#{designName}.#{target.identifier}" && snippet.content[target.contentField]?


  constructTeasers: (publications) ->
    teasers = []
    for publication in publications
      # the title
      title = publication.metadata.title if publication.metadata?.title
      title ?= @deduceTitleFromData(publication.data.content, publication.data.design.name)
      # the teaser image
      teaserImage = publication.metadata.teaser_image if publication.metadata?.teaser_image
      teaserImage ?= @deduceTeaserImageFromData(publication.data.content, publication.data.design.name)
      # the link target
      documentId = publication.document_id
      mongoId = publication._id
      teasers.push {title, teaserImage, documentId, mongoId}
      title = teaserImage = documentId = mongoId = undefined
    teasers


  getTeasers: ->
    @constructTeasers(@articles)
