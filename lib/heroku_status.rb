require "heroku_status/version"
require "faraday"
require "json"

# https://devcenter.heroku.com/articles/heroku-status#heroku-status-api-v3
module HerokuStatus
  module_function

  # Retrieve the current issue status from Heroku
  # @return {hash}
  def current_status
    response = Faraday.get("https://status.heroku.com/api/v3/current-status")
    if response.status != 200
      Errors.error(response, "An issue occured while fetching current issue status.")
    else
      JSON.parse(response.body)
    end
  end

  # Retrieve a list of issues from Heroku with optional filters
  # @param {hash} filters
  # - {string} since - 2012-04-24
  # - {integer} limit - 1
  # @return {hash}
  def issues(filters={})
    filter_since = filters[:since] ? `since=#{filters[:since]}` : ""
    filter_limit = filters[:limit] ? `limit=#{filters[:limit]}` : ""
    response = Faraday.get("https://status.heroku.com/api/v3/issues?#{filter_since}&#{filter_limit}")
    if response.status != 200
      HerokuStatus::Errors.error(response, "An issue occured while fetching issues.")
    else
      JSON.parse(response.body)
    end
  end

  # Return a response for a particular issue
  # @param {integer} issue_id
  # @return {hash}
  def issue(issue_id)
    response = Faraday.get("https://status.heroku.com/api/v3/issues/#{issue_id}")
    if response.status != 200
      HerokuStatus::Errors.error(response, "An issue occured while fetching the issue.")
    else
      JSON.parse(response.body)
    end
  end

  module Errors
    module_function
    def error(res, msg)
      {
        status: "error",
        message: msg,
        error_code: res.status,
        body: res.body
      }
    end
  end
end
