# ruby main.rb

require "minitest/autorun"

def echo(value)
  value
end

describe "echo" do
  it "works" do
    echo(123).must_equal 123
  end
end
