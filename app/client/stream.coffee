createiFrameTag = ({ element, width, height }) ->
  iframe = element.ownerDocument.createElement('iframe')
  iframe.src = 'about:blank'
  iframe.setAttribute('width', width)
  iframe.setAttribute('height', height)
  iframe


# Poll for readyState of contentDocument
# -> cross-browser solution (onload does not work on mobile browsers)
waitForIFrameLoad = (iframe, cb) ->
  if iframe.contentDocument?.readyState == 'complete'
    cb()
  else
    setTimeout ->
      waitForIFrameLoad(iframe, cb)
    , 30


tryRenderIFrame = (view) ->
  if Session.get('articleHtml')
    iframe = createiFrameTag
      element: view.firstNode
      width: '100%'
      height: '100%'

    waitForIFrameLoad iframe, ->
      iframe.contentDocument.body.style.cssText = (
        'margin: 0px;' +
        'padding: 0px;' +
        'height: 100%;' +
        'width: 100%;'
      )
      $css = $('<link rel="stylesheet" href="http://livingdocs-beta.io/designs/timeline/css/fixed_width_fluid/all.css">')
      $(iframe.contentDocument.head).append($css)
      $(iframe.contentDocument.body).append(Session.get('articleHtml'))
      # Reset articleHtml session variable
      Session.set('articleHtml', undefined)
    # Append IFrame to the DOM
    $(view.firstNode).append(iframe)
  else
    setTimeout ->
      tryRenderIFrame(view)
    , 30


Template.ArticleStream.articles = ->
  Session.get("articleList")


Template.article.rendered = ->
  tryRenderIFrame(this)

