RSpec.describe HerokuStatus do
  describe "Version" do
    it "has a version number" do
      expect(HerokuStatus::VERSION).not_to be nil
    end
  end

  describe "#current_status"
end
