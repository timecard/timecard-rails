class IssueRuffnote < Provider
  store_into :info do |a|
    number
    html_url
  end

end
