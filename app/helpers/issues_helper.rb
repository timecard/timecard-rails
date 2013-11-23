module IssuesHelper
  def provider_number(issue)
    if issue.github
      "##{issue.github.number}"
    elsif issue.ruffnote
      "##{issue.ruffnote.number}"
    else
      ""
    end
  end

  def provider_url(issue)
    if issue.github
      issue.github.html_url
    elsif issue.ruffnote
      issue.ruffnote.html_url
    else
      ""
    end
  end
end
