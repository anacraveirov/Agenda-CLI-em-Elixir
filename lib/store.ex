defmodule AgendaCli.Store do
  def load do
    if File.exists?("contacts.json") do
      "contacts.json"
      |> File.read!()
      |> Jason.decode!()
    else
      []
    end
  end

  def save(contatos) do
    json = Jason.encode!(contatos, pretty: true)
    File.write!("contacts.json", json)
  end
end