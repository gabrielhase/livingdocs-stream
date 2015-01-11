Template.Article.article = ->
  # we set this to the session since we will render in an Iframe
  # asynchronously
  Session.set('articleHtml', @article.html)
  Session.set('designName', @article.data.design.name)


# After render hook -> ensures that the Iframe parent container is present
Template.Article.rendered = ->
  tryRenderIFrame(this)


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


addToHead = (iframe, $element) ->
  $(iframe.contentDocument.head).append($element)


createHtml = (design, html) ->
  $html = $(design.wrapper)
  $docSection = $html.find('.doc-section')
  $docSection.append(html)
  $html


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

      design = getDesign(Session.get('designName'))
      addToHead(iframe, $("<link rel='stylesheet' href='#{design.css}'>"))
      addToHead(iframe, $('<script src="//use.resrc.it/"></script>'))

      $html = createHtml(design, Session.get('articleHtml'))
      $(iframe.contentDocument.body).append($html)
      $images = $(iframe.contentDocument.body).find('.resrc')
      for $image in $images
        resrc.resrc($image)
      # Reset articleHtml session variable
      Session.set('articleHtml', undefined)
    # Append IFrame to the DOM
    $(view.firstNode).html(iframe)
  else
    setTimeout ->
      tryRenderIFrame(view)
    , 30


getDesign = (designName) ->
  switch designName
    when 'timeline'
      css: '/designs/timeline.css'
      wrapper: """
        <div>
          <div class='funky-wrapper doc-section'>
          </div>
        </div>
      """
    when 'morpheus'
      css: '/designs/morpheus.css'
      wrapper: """
        <section class="livingdocs-edit-area">
          <article class="article-full articlebody fullarticle fullarticle__body doc-section">
          </article>
        </section>
      """


