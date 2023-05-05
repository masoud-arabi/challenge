require 'challenge'

RSpec.describe Controller do 
  describe "#all" do
    it "returns the number of companies" do
      @controller = Controller.new('./data/companies.json', './data/users.json')
      expect(@controller.list_all_info[1..13]).to eql("Company_id: 1")
    end
  end
end

