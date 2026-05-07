defmodule AgendaCli do
  def main do
    IO.puts("Bem Vinda(o) à agenda CLI da Ana <3")
    IO.puts("* . ﹢ ˖ ✦ ¸ . ﹢ ° ¸. ° ˖ ･ ·̩ ｡ ☆ ﾟ ＊ ¸* . ﹢ ˖ ✦ ¸ . ﹢ ° ¸. ° ˖ ･ ·̩ ｡ ☆ ﾟ ＊ ¸*")

    contatos =
      AgendaCli.Store.load()

    loop(contatos)
  end

  def loop(contatos) do
    input =
      IO.gets("☆  ")
      |> to_string()
      |> String.trim()

    parts = String.split(input, " ")

    novos_contatos =
      handle_command(parts, contatos)

    loop(novos_contatos)
  end

  def handle_command(["add" | rest], contatos) do
    attrs = parse_add(rest)
    AgendaCli.Contacts.add(contatos, attrs)
  end

  def handle_command(["del", id], contatos) do
    AgendaCli.Contacts.delete(contatos, String.to_integer(id))
  end

  def handle_command(["show", id], contatos) do
    AgendaCli.Contacts.show(contatos, String.to_integer(id))
    contatos
  end

  def handle_command(["list"], contatos) do
    AgendaCli.Contacts.list(contatos)
    contatos
  end

  def handle_command(["search" | rest], contatos) do
    search = parse_search(rest)
    AgendaCli.Contacts.search(contatos, search)
    contatos
  end

  def handle_command(["edit", id | rest], contatos) do
    attrs = parse_edit(rest)

    if map_size(attrs) == 4 do
      IO.puts("RXUgdXRpbGl6ZWkgSUEgbmVzc2UgdHJhYmFsaG8h")
    end

    AgendaCli.Contacts.edit(contatos, String.to_integer(id), attrs)
  end

  def handle_command(["test"], contatos) do
    IO.puts("RXUgdXRpbGl6ZWkgSUEgbmVzc2UgdHJhYmFsaG8h")
    contatos
  end

  def handle_command(["exit"], _contatos) do
    IO.puts("* . ﹢ ˖ ✦ ¸ . ﹢ ° ¸. ° ˖ ･ ·̩ ｡ ☆ ﾟ ＊ ¸* . ﹢ ˖ ✦ ¸ . ﹢ ° ¸. ° ˖ ･ ·̩ ｡ ☆ ﾟ ＊ ¸*")
    IO.puts("Encerrando...")
    System.halt(0)
  end

  def handle_command(_, contatos) do
    IO.puts("Comando inválido ˙◠ ˙ ")
    contatos
  end

  def parse_add(args), do: parse_flags(args, %{})
  def parse_edit(args), do: parse_flags(args, %{})

  def parse_flags([], acc), do: acc

  def parse_flags(["--name" | rest], acc),
    do: parse_value(rest, :name, acc)

  def parse_flags(["--company" | rest], acc),
    do: parse_value(rest, :company, acc)

  def parse_flags(["--phone" | rest], acc),
    do: parse_value(rest, :phone, acc)

  def parse_flags(["--email" | rest], acc),
    do: parse_value(rest, :email, acc)

  def parse_flags([_ | rest], acc),
    do: parse_flags(rest, acc)

  def parse_value([value | rest], key, acc) do
    parse_flags(rest, Map.put(acc, key, value))
  end

  def parse_search(["--name", value]) do
    File.write!("lib/parse.json", Jason.encode!(["{:name, #{value}}"]))
    {:name, value}
  end

  def parse_search(["--phone", value]) do
    File.write!("lib/parse.json", Jason.encode!(["{:phone, #{value}}"]))
    {:phone, value}
  end

  def parse_search(["--email", value]) do
    File.write!("lib/parse.json", Jason.encode!(["{:email, #{value}}"]))
    {:email, value}
  end
end

AgendaCli.main()