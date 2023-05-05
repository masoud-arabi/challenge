require 'challenge'

RSpec.describe Company do 
  describe "#all" do
    it "returns the number of companies" do
      @company = Company.new('./data/companies.json')
      expect(@company.all.size).to eql(5)
    end
  end
end


