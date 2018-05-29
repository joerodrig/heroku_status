
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
                     to_return(status: 200, body: tasks_response.to_json, headers: {})
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
    # TODO
  end
end
