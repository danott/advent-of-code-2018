# mix test

defmodule Echo do
  def echo(value) do
    value
  end
end

defmodule EchoTest do
  use ExUnit.Case

  test "works" do
    assert Echo.echo(123) == 123
  end
end
