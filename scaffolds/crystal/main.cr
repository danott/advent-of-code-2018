# crystal spec main.cr
# crystal run main.cr

require "spec"

def echo(value)
  value
end

describe "echo" do
  it "works" do
    echo(123).should eq(123)
  end
end
