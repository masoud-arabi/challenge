require 'challenge'

RSpec.describe User do 
    describe "#all" do
      it "returns the number of users" do
        @user = User.new('./data/users.json')
        expect(@user.all.size).to eql(35)
      end
    end
  end