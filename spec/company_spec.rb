require 'challenge'

RSpec.describe Company do 
  describe "#all" do
    it "returns the number of companies" do
      @company = Company.new('./data/companies.json')
      expect(@company.all.size).to eql(5)
    end

    it "returns the number of companies" do
      @company = Company.new('./data/companies.json')
      expect(@company.all.first['id']).to eql(1)
      expect(@company.all.last['id']).to eql(5)
    end
  end
end


