defmodule MiniHomebroke.Ordens do
  @moduledoc """
  The Ordens context.
  """

  import Ecto.Query, warn: false
  alias MiniHomebroke.Repo

  alias MiniHomebroke.Ordens.Ordem

  def get_operacao!(codigo_ativo) do
    query =
      from o in "ordens",
        where: o.codigo_ativo == ^codigo_ativo,
        select: %{data: o.inserted_at, tipo: o.tipo, valor: o.valor}

    operacao = Repo.all(query)

    query =
      from o in "ordens",
        where: o.codigo_ativo == ^codigo_ativo and o.tipo == 1,
        select: type(sum(o.valor), :float)

    saldo1 = Repo.all(query)

    query =
      from o in "ordens",
        where: o.codigo_ativo == ^codigo_ativo and o.tipo == 2,
        select: type(sum(-o.valor), :float)

    saldo2 = Repo.all(query)

    case Enum.at(saldo1, 0) do

      nil ->
        case Enum.at(saldo2, 0) do

          nil ->
            result = %{saldo: 0, operacoes: operacao}
            result

          _->
            result = %{saldo: Enum.at(saldo2, 0), operacoes: operacao}
            result

        end

      _->
        case Enum.at(saldo2, 0) do

          nil ->
            result = %{saldo: Enum.at(saldo1, 0), operacoes: operacao}
            result

          _->
            result = %{saldo: Enum.at(saldo1, 0) + Enum.at(saldo2, 0), operacoes: operacao}
            result

        end
    end

  end

  @doc """
  Returns the list of ordens.

  ## Examples

      iex> list_ordens()
      [%Ordem{}, ...]

  """
  def list_ordens do
    Repo.all(Ordem)
  end

  @doc """
  Gets a single ordem.

  Raises `Ecto.NoResultsError` if the Ordem does not exist.

  ## Examples

      iex> get_ordem!(123)
      %Ordem{}

      iex> get_ordem!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ordem!(id), do: Repo.get!(Ordem, id)

  @doc """
  Creates a ordem.

  ## Examples

      iex> create_ordem(%{field: value})
      {:ok, %Ordem{}}

      iex> create_ordem(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ordem(attrs \\ %{}) do
    %Ordem{}
    |> Ordem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ordem.

  ## Examples

      iex> update_ordem(ordem, %{field: new_value})
      {:ok, %Ordem{}}

      iex> update_ordem(ordem, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ordem(%Ordem{} = ordem, attrs) do
    ordem
    |> Ordem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ordem.

  ## Examples

      iex> delete_ordem(ordem)
      {:ok, %Ordem{}}

      iex> delete_ordem(ordem)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ordem(%Ordem{} = ordem) do
    Repo.delete(ordem)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ordem changes.

  ## Examples

      iex> change_ordem(ordem)
      %Ecto.Changeset{data: %Ordem{}}

  """
  def change_ordem(%Ordem{} = ordem, attrs \\ %{}) do
    Ordem.changeset(ordem, attrs)
  end
end
