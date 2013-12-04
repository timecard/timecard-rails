module ApplicationHelper
  def formatted_time_distance(start_time, end_time)
    sec = end_time - start_time
    hour = (sec / (60 * 60)).floor
    sec = sec - (hour * 60 * 60)
    min = (sec / 60).floor
    sec = sec - (min * 60)
    "#{sprintf('%02d', hour)} hour #{sprintf('%02d', min)} min #{sprintf('%02d', sec)} sec"
  end

  def formatted_time(sec)
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
    markdown(text)
  end

  def link_to_provider(issue)
    if issue.github
      link_to "##{issue.github.number}", issue.github.html_url, target: "_blank"
    elsif issue.ruffnote
      link_to "##{issue.ruffnote.number}", issue.ruffnote.html_url, target: "_blank"
    else
      ""
    end

  end

  def markdown(text)
    extentions = {
      autolink: true,
      space_after_headers: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true
    }
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      filter_html: true,
      link_attributes: { target: '_blank' }
    )
    markdown = Redcarpet::Markdown.new(renderer, extentions)
    # Ref http://qa.atmarkit.co.jp/q/76
    text ? (raw markdown.render(text).encode("UTF-16BE", "UTF-8", invalid: :replace, undef: :replace, replace: '?').encode("UTF-8")) : ""
  end
end
