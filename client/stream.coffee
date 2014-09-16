Template.ArticleStream.articles = ->
  Session.get("articleList")


# Render article in an iframe so you don't have css conflicts
Template.article.rendered = ->
  iframe = $('iframe')[0].contentDocument
  $css = $('<link rel="stylesheet" href="http://livingdocs-beta.io/designs/timeline/css/fixed_width_fluid/all.css">')
  $(iframe.head).append($css)
  $(iframe.body).append(Session.get("articleHtml"))
