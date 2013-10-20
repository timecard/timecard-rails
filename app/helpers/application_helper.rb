module ApplicationHelper
  def formatted_time_distance(start_time, end_time)
    sec = end_time - start_time
    hour = (sec / (60 * 60)).floor
    sec = sec - (hour * 60 * 60)
    min = (sec / 60).floor
    sec = sec - (min * 60)
    "#{sprintf('%02d', hour)} hour #{sprintf('%02d', min)} min #{sprintf('%02d', sec)} sec"
  end

  def hbr(text)
    text = h(text)
    text = text.gsub(/https?:\/\/.*$/){|text|
      text = text.gsub("\r", "")
      tr = truncate(text, length:50)
      link_to tr, text, {target: "_blank"}
    }
    simple_format(text, {}, sanitize: false)
  end

end
