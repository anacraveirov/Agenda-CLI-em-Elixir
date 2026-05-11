defmodule AgendaCli.Contacts do
  def add(contatos, attrs) do
    contato = %{
      id: System.system_time(:millisecond),
      name: Map.get(attrs, :name, ""),
      company: Map.get(attrs, :company, ""),
      phone: Map.get(attrs, :phone, ""),
      email: Map.get(attrs, :email, "")
    }

    novos_contatos = contatos ++ [contato]

    AgendaCli.Store.save(novos_contatos)

    IO.puts("Contato adicionado (>ᴗ•) !!")

    novos_contatos
  end

  def delete(contatos, id) do
    existe? =
      Enum.any?(contatos, fn contato ->
        contato["id"] == id || contato[:id] == id
      end)

    if existe? do
      novos_contatos =
        Enum.reject(contatos, fn contato ->
          contato["id"] == id || contato[:id] == id
        end)

      AgendaCli.Store.save(novos_contatos)

      IO.puts("Contato removido (>ᴗ•) !!")

      novos_contatos
    else
      IO.puts("Contato não encontrado (◡ ︵◡ )")

      contatos
    end
  end

  def show(contatos, id) do
    contato =
      Enum.find(contatos, fn contato ->
        contato["id"] == id || contato[:id] == id
      end)

    if contato do
      IO.inspect(contato)
    else
      IO.puts("Contato não encontrado (◡ ︵◡ )")
    end
  end

  def list(contatos) do
    Enum.each(contatos, fn contato ->
      IO.inspect(contato)
    end)
  end

  def search(contatos, {_campo, valor}) do
    valor = String.downcase(valor)

    contatos
    |> Enum.filter(fn contato ->
      Enum.any?(contato, fn {_k, v} ->
        String.contains?(String.downcase(to_string(v)), valor)
      end)
    end)
    |> Enum.each(&IO.inspect/1)
  end

  def edit(contatos, id, attrs) do
    existe? =
      Enum.any?(contatos, fn contato ->
        contato["id"] == id || contato[:id] == id
      end)

    if existe? do
      novos_contatos =
        Enum.map(contatos, fn contato ->
          contato_id = contato["id"] || contato[:id]

          if contato_id == id do
            Map.merge(contato, convert_keys(attrs))
          else
            contato
          end
        end)

      AgendaCli.Store.save(novos_contatos)

      IO.puts("Contato atualizado (>ᴗ•) !!")

      novos_contatos
    else
      IO.puts("Contato não encontrado (◡ ︵◡ )")

      contatos
    end
  end

  defp convert_keys(map) do
    Enum.into(map, %{}, fn {k, v} ->
      {Atom.to_string(k), v}
    end)
  end
end
