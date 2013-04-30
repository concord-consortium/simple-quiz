class PublishingController < ApplicationController
  def publish
    activity = {
      "name" => "Simple Quiz",
      "description" => "A simple, one-question quiz.",
      "url" => root_url,
      "create_url" => responses_run_url
    }

    page = {
      "name" => "Response",
      "elements" => [
        {
          "type" => "open_response",
          "id" => "1",
          "prompt" => "Why is the sky blue?"
        }
      ]
    }

    section = {
      "name" => "Simple Quiz Section",
      "pages" => [page]
    }

    activity["sections"] = [section]
    portal_url = (ENV['CONCORD_PORTAL_URL'] || "http://localhost:3000") + '/external_activities/publish'
    bearer_token = 'Bearer %s' % current_user.token
    response = HTTParty.post(portal_url, :body => activity.to_json, :headers => {"Authorization" => bearer_token, "Content-Type" => 'application/json'})
    if response.code == 201
      # success
      flash[:notice] = "Successfully published to portal: #{response.headers["Location"]}"
    else
      # error
      flash[:error] = "Failed to publish to portal!"
    end
    redirect_to root_path
  end
end