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
        'padding: 0px;' +
        'height: 100%;' +
        'width: 100%;'
      )
      $css = $('<link rel="stylesheet" href="/designs/morpheus.css">')
      $(iframe.contentDocument.head).append($css)
      html = """
      <section class="livingdocs-edit-area">
        <article class="article-full articlebody fullarticle fullarticle__body doc-section">
          #{Session.get('articleHtml')}
        </article>
      </section>
      """
      $(iframe.contentDocument.body).append(html)
      $images = $(iframe.contentDocument.body).find('.resrc')
      for $image in $images
        resrc.resrc($image)
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

