Future = Npm.require('fibers/future')

# Handling of async code:
# - http://stackoverflow.com/questions/24743402/how-to-get-an-async-data-in-a-function-with-meteor
# - https://www.eventedmind.com/feed/meteor-what-is-meteor-bindenvironment


saveArticles = (publications) ->
  for publication in publications
    saveArticle(publication)


saveArticle = (publication) ->
  d = new Date(publication.created_at)
  publication.created_at = d
  Articles.upsert
    document_id: publication.document_id
  , publication, {write: true}


Meteor.startup ->
  fut = new Future()

  webhookHandler = Meteor.bindEnvironment (err, res) ->
    return fut.throw(new Error("Request error: #{err}")) if err
    fut.return('all setup')
  , (exception) ->
    fut.throw(new Error("Exception while setting up webhook"))

  # listen to all publications from all spaces
  Meteor.http.call("POST",
    "#{Meteor.settings.apiUrl}/webhooks/publications/subscribe",
    data:
      url: "#{Meteor.settings.url}/publication"
  , webhookHandler)
, (exception) ->
  fut.throw(new Error("Exception while getting documents"))

  fut.wait()


# Server side webhook
Router.route '/publication', ->
  saveArticle(@request.body.publication)
, where: 'server'

