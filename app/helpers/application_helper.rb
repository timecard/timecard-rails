module ApplicationHelper
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

  def gravatar_url(email, size=50)
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=#{size}"
  end

  def calc_label_color(color)
    rbg = color.scan(/.{1,2}/)
    if rbg.inject(0) { |sum,i| sum += i.hex } < 382
      "color:#ffffff;background-color:##{color}"
    else
      "color:#333333;background-color:##{color}"
    end
  end
end
