Template.ArticleStream.articles = ->
  Session.get("articleList")


Template.article.article = ->
  Session.get("articleHtml")
