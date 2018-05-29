# require "heroku_status/version"
require "Faraday"
require "json"

# https://devcenter.heroku.com/articles/heroku-status#heroku-status-api-v3
module HerokuStatus
  module_function

  # Retrieve the current issue status from Heroku
  # @return {hash}
  def current_status
    response = Faraday.get("https://status.heroku.com/api/v3/current-status")
    JSON.parse(response.body)
  end

  # Retrieve a list of issues from Heroku with optional filters
  # @param {hash} filters
  # - {string} since - 2012-04-24
  # - {integer} limit - 1
  # @return {hash}
  def issues(filters={})
    filter_since = filters[:since] ? `since=#{filters[:since]}` : ""
    filter_limit = filters[:limit] ? `limit=#{filters[:limit]}` : ""
    response = Faraday.get(`https://status.heroku.com/api/v3/issues?#{filter_since}&#{filter_limit}`)
    JSON.parse(response.body)
  end

  # Return a response for a particular issue
  # @param {integer} issue_id
  # @return {hash}
  def issue(issue_id)
    response = Faraday.get(`https://status.heroku.com/api/v3/issues/#{issue_id}`)
    JSON.parse(response.body)
  end
end
