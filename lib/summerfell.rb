module Summerfell
  def self.conn
    @conn ||= begin
      opts = url: Figaro.env.app_host
      opts.merge!(ssl: { ca_path: Figaro.env.ca_path }) if Rails.env.production?
      Faraday.new(opts) do |faraday|
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
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