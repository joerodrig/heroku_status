
RSpec.describe HerokuStatus do
  subject { HerokuStatus }
  describe "Version" do
    it "has a version number" do
      expect(HerokuStatus::VERSION).not_to be nil
    end
  end

  describe "#current_status" do
    describe "No issues exist" do
      before do
        current_status_response = {
            "status" => {
              "Production" => "green",
              "Development" => "green"
            },
            "issues" => []
        }

        @current_status_req = stub_request(:get, "https://status.heroku.com/api/v3/current-status").
                     to_return(status: 200, body: current_status_response.to_json, headers: {})
      end

      it "should return all green statuses" do
        subject.current_status
        expect(@current_status_req).to have_been_requested
      end
    end
  end

  describe "#issues" do
    # TODO
  end

  describe "#issue" do
    describe "Valid issue exists" do
      before do
        issue_response = {
          "id": 6,
          "created_at": "2009-10-23T18:49:49.000Z",
          "updated_at": "2012-06-22T23:41:10.468Z",
          "title": "Limited app interruption",
          "resolved": true,
          "upcoming": false,
          "status_dev": "green",
          "status_prod": "green",
          "href": "https://status.heroku.com/api/v3/issues/6",
          "full_url": "https://status.heroku.com/incidents/6",
          "updates": [
            {
              "id": 10,
              "created_at": "2009-10-23T20:20:46.000Z",
              "updated_at": "2012-06-22T23:41:05.896Z",
              "incident_id": 6,
              "update_type": "resolved",
              "contents": "The instances affected by the EC2 hardware failure were in our database cluster. These instances have been restored, and database migrated with no data loss. \n\nThe recovery took slightly longer than expected, taking all necessary precautions to prevent data loss.\n\nIndividual applications are coming back online now.\n",
              "title": nil,
              "status_dev": "green",
              "status_prod": "green"
            },
            {
              "id": 9,
              "created_at": "2009-10-23T18:49:49.000Z",
              "updated_at": "2012-06-22T23:41:05.988Z",
              "incident_id": 6,
              "update_type": "issue",
              "contents": "An Amazon hardware failure is impacting 187 Heroku applications right now.\nOur cloud has identified the failure, and is automatically brining the applications up on new instances.\nWe expect full restoration of service in <15 minutes.",
              "title": nil,
              "status_dev": "green",
              "status_prod": "yellow"
            }
          ]
        }

        @issue_req = stub_request(:get, "https://status.heroku.com/api/v3/issues/6").
                     to_return(status: 200, body: issue_response.to_json, headers: {})
      end
      it "should return the issue" do
        subject.issue(6)
        expect(@issue_req).to have_been_requested
      end
    end

    describe "Invalid issue" do
      before do
        issue_response = {
                status: "error",
                message: "An issue occured while fetching the issue.",
                error_code: 500,
                body: "More info..."
        }

        @issue_req = stub_request(:get, "https://status.heroku.com/api/v3/issues/0").
                     to_return(status: 500, body: issue_response.to_json, headers: {})
      end

      it "should throw a 500" do
        subject.issue(0)
        expect(@issue_req).to have_been_requested
      end
    end
  end
end
