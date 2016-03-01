module Summerfell
  def self.conn
    @conn ||= Faraday.new(url: Figaro.env.app_host) do |faraday|
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def self.get(path, params={})
    raw = conn.get do |req|
      req.url path, params
    end

    JSON.parse(raw.body)
  end

  def self.post(path, params={})
    raw = conn.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.body = params.to_json
    end

    JSON.parse(raw.body)
  end
end