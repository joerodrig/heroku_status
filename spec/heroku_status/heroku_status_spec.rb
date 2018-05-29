
RSpec.describe HerokuStatus do
  describe "Version" do
    it "has a version number" do
      expect(HerokuStatus::VERSION).not_to be nil
    end
  end

  describe "#current_status" do
    describe "No issues exist" do
      it "should return all green" do
        # TODO: Mock req/response
        # expect(HerokuStatus.current_status).to eq(
        #   {
        #     "status" => {
        #       "Production" => "green",
        #       "Development" => "green"
        #     },
        #     "issues" => []
        #   }
        # )
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
