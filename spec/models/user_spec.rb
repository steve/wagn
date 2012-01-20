require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe "User" do
  describe "#read_rules" do
    before(:all) do
      @read_rules = User.as(:joe_user) { User.read_rules }
    end

    
    it "*all+*read should apply to Joe User" do
      @read_rules.member?(Card.fetch('*all+*read').id).should be_true
    end
    
    it "3 more should apply to Joe Admin" do
      User.as(:joe_admin) do
        ids = User.read_rules
        #warn "rules = #{ids.map{|id| Card.find(id).name}.join ', '}"
        ids.length.should == @read_rules.size+3
      end
    end
    
  end
end
