defmodule Pento.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_first_name, do: "John"
  def valid_second_name, do: "Doe"
  def valid_phone, do: "254712345678"


  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      first_name: valid_first_name(),
      second_name: valid_second_name(),
      phone: valid_phone(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Pento.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
