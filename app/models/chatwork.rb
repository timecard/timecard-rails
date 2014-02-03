class Chatwork
  def self.post body
    base_url = 'https://api.chatwork.com/v1'
    room_id = 16920606
    url = "/rooms/#{room_id}/messages"
    token = Authentication.get_chatwork_token
    `curl -X POST -H "X-ChatWorkToken: #{token}" -d "body=#{body}" "#{base_url}#{url}"`
  end
end
