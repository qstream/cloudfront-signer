defmodule CloudfrontSigner.PolicyTest do
  use ExUnit.Case, async: true

  test "use default encoder" do
    assert %{ "Statement" => [first_statement | _]} = to_string(%CloudfrontSigner.Policy{resource: "boe/bah",
                                                                                         expiry: 1643638730})
    |> Poison.decode!

    assert first_statement["Resource"] == "boe/bah"
    assert first_statement["Condition"]["DateLessThan"]["AWS:EpochTime"] == 1643638730
  end

  describe "with custom encoder" do

    setup context do
      old_encoder = Application.get_env(:cloudfront_signer, :json_codec)
      Application.put_env(:cloudfront_signer, :json_codec, CustomEncoder)

      on_exit(context, fn ->
        Application.put_env(:cloudfront_signer, :json_codec, old_encoder)
      end)
      :ok
    end

    test "use custom encoder" do
      assert %{status: "ok"} = to_string(%CloudfrontSigner.Policy{resource: "boe/bah", expiry: 1643638730})
      |> Poison.decode!(%{keys: :atoms})
    end
  end
end
