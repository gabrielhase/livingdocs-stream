Future = Npm.require('fibers/future')

# Handling of async code:
# - http://stackoverflow.com/questions/24743402/how-to-get-an-async-data-in-a-function-with-meteor
# - https://www.eventedmind.com/feed/meteor-what-is-meteor-bindenvironment


# just skip articles that are already there
saveArticles = (publications) ->
  for publication in publications
    Articles.upsert
      document_id: publication.document_id
    , publication, {write: true}


Meteor.startup ->
  console.log "RUNNING STARTUP SYNC"
  fut = new Future()
  handler = Meteor.bindEnvironment (err, res) ->
    return fut.throw(new Error("Request error: #{err}")) if err
    saveArticles(res.data.publications)
    fut.return(res.data.publications)
  , (exception) ->
    fut.throw(new Error("Exception while getting documents"))

  Meteor.http.call("GET", "#{Meteor.settings.apiUrl}/public?fields=html,data,document_id", handler)

  fut.wait()
