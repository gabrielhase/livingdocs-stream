@Articles = new Mongo.Collection('articles')

if Meteor.isServer
  # Collection setup
  @Articles._ensureIndex('document_id', {unique: 1})
  Meteor.publish 'articles', =>
    @Articles.find({}, {sort: {created_at: -1}})
  Meteor.publish 'article', (id) =>
    @Articles.find({_id: id})
