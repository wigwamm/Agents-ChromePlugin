#rootPath = 'http://localhost:8000/Build'
rootPath = 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin'

validSite = null
if window.location.host.indexOf('rightmove.co.uk') != -1
  validSite = 'rightmove'
else if window.location.host.indexOf('zoopla.co.uk') != -1
  validSite = 'zoopla'

return if validSite == null

jsPath = "#{rootPath}/js/#{validSite}_bookmark.js"
jqueryPath = "#{rootPath}/js/jquery.js"
cssPath = "#{rootPath}/css/#{validSite}.css"

addScript = (scriptUrl) ->
  scriptTag = document.createElement('script')
  scriptTag.setAttribute('src', scriptUrl)
  document.head.appendChild(scriptTag)

addStylesheet = (styleUrl) ->
  styleTag = document.createElement('link')
  styleTag.setAttribute('rel', 'stylesheet')
  styleTag.setAttribute('href', styleUrl)
  document.head.appendChild(styleTag)

addScript(jsPath)
addScript(jqueryPath)
addStylesheet(cssPath)
