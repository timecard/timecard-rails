class Util
  @formatWorkHours: (start, end) ->
    total = end - start
    hour = Math.floor(total/(60*60*1000))
    total = total-(hour*60*60*1000)
    min = Math.floor(total/(60*1000))
    total = total-(min*60*1000)
    sec = Math.floor(total/1000)
    hour = Util.zeroPadding(hour, 2)
    min = Util.zeroPadding(min, 2)
    sec = Util.zeroPadding(sec, 2)
    "#{hour} hour #{min} min #{sec} sec"

  @formatTime: (time_str) ->
    time = new Date(time_str)
    "#{time.getHours()}:#{Util.zeroPadding(time.getMinutes(), 2)}"

  @zeroPadding: (number, length) ->
    (Array(length).join('0') + number).slice(-length)

window.Util = window.Util || Util
