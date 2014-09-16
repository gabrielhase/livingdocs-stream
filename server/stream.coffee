Future = Npm.require('fibers/future')

mockMeta =
  teaser_image: 'http://app.resrc.it/https://livingdocs-images-dev.s3.amazonaws.com/6a164594-7f6c-43fa-8977-1d1ed64a0120'
  title: 'Travelling to wonderland'
  caption: 'Have you ever wanted to follow in the steps of ...'

# Handling of async code:
# - http://stackoverflow.com/questions/24743402/how-to-get-an-async-data-in-a-function-with-meteor
# - https://www.eventedmind.com/feed/meteor-what-is-meteor-bindenvironment

Meteor.methods

  article: (id) ->
    fut = new Future()
    handler = Meteor.bindEnvironment (err, res) ->
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
      publication.meta = mockMeta for publication in res.data.publications
      fut.return(res)
    , (exception) ->
      fut.throw(new Error("Exception while getting documents"))

    Meteor.http.call("GET", "#{Meteor.settings.apiUrl}/public", handler)

    fut.wait()
