now = -> new Date()
timeago = (time)-> Math.round((now() - time) / 1000)
timer = null
dateKey = (date)->
  "#{date.getFullYear()}#{date.getUTCMonth() + 1}#{date.getUTCDate()}"

displayTime = (time)->
  minutes = Math.floor(time / 60)
  minutes = "0#{minutes}" if minutes < 10
  seconds = time % 60
  seconds = "0#{seconds}" if seconds < 10
  "#{minutes}:#{seconds}"

class Timer
  start: ->
    @startTime = new Date()
    @updateLoop($('.current .bar')) unless @updater?
    $('#start').hide()
    $('#stop').show()

  stop: ->
    clearInterval(@updater)
    @saveHistory()
    timer = new RestTimer(timeago @startTime)
    timer.start()

  saveHistory: ->
    @renderSession timeago @startTime
    localStorage[dateKey(now())] += timeago(@startTime) + " "

  renderSession: (session)->
    return if session is "" or session is 0
    $('.history')
      .prepend("<div class='progress'><div class='bar' style='width:#{session / 60}%'/></div>")
      .prepend("<h2 class='well'>Flow : #{displayTime session}</h2>")

  updateLoop: (bar)->
    clock = $('#clock')
    @updater = setInterval =>
      time = timeago @startTime
      clock.text(displayTime time)
      bar.css('width', "#{time / 60}%")
    , 1000

class RestTimer
  constructor: (time)->
    @time = Math.round(time / 5)
    @originTime = @time

  start: ()->
    @updateLoop($('.current .bar')) unless @updater?
    $('#start').hide()
    $('#stop').show()

  stop: ()->
    clearInterval(@updater)
    @saveHistory()
    timer = new Timer()
    $('#start').show()
    $('#stop').hide()

  saveHistory: ->
    $('.history').prepend("<h2>Rest #{displayTime @originTime}</h2>")

  updateLoop: (bar)->
    clock = $('#clock')
    @updater = setInterval =>
      clock.text(displayTime @time--)
      bar.css('width', "#{(@time / @originTime) * 100 }%")
      @stop() if @time < 0
    , 1000

$ ->
  timer = new Timer()
  localStorage[dateKey(now())] or= ""
  sessions = localStorage[dateKey(now())].trim().split(" ")
  sessions.forEach timer.renderSession

  $('#start').click (event)-> timer.start()
  $('#stop').click (event)-> timer.stop()
  $('#reset').click (event)->
    localStorage[dateKey(now())] = ""
    $('.history').empty()
