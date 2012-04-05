# Pull data from a Drupal link mentioned
#
module.exports = (robot) ->

  titlePattern     = ///<title>(.*?)\s\|\s(drupal.org|Drupal\sGroups)</title>///
  projectPattern   = ///<td>Project:</td><td>(.*)</td>///
  componentPattern = ///<td>Component:</td><td>(.*)</td>///
  priorityPattern  = ///<td>Priority:</td><td>(.*)</td>///
  statusPattern    = ///<td>Status:</td><td>(.*)</td>///   

  robot.hear /(http:\/\/(groups.)?drupal.org\/node\/\d+)/i, (msg) ->
    pullDrupalInfo(msg.match[0], msg)

  robot.hear /^#?(\d{4,})$/i, (msg) ->
    pullDrupalInfo("http://drupal.org/node/#{msg.match[1]}", msg)

  pullDrupalInfo = (url, msg) ->
    msg.http(url)
      .get() (err, res, body) ->
        titleMatches = body.match(titlePattern)
        title = titleMatches[1] || "Could not determine title"
        message = "#{url} => #{title}"
        projectMatches = body.match(projectPattern)
        if projectMatches
          componentMatches = body.match(componentPattern)
          priorityMatches = body.match(priorityPattern)
          statusMatches = body.match(statusPattern)
          message = message + " => " + [projectMatches[1], componentMatches[1], priorityMatches[1], statusMatches[1]].join(", ")

        msg.reply message
        
        
        