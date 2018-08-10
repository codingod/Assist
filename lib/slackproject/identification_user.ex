defmodule Slackproject.IdentificationUser do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Slackproject.IdentificationUser
  alias Poison.Encoder

  schema "users" do
    field :userid, :string
    field :teamid, :string
    field :tag, :string

    timestamps()
  end

  def format(user) do
    %{
      :userid => user.userid,
      :teamid => user.teamid,
      :tag => user.tag
    }
  end

  def all() do
    Repo.all(IdentificationUser)
  end
######

  @doc false
  def changeset(%IdentificationUser{} = user, attrs) do
    user
    |> cast(attrs, [:userid, :teamid, :tag])
    |> validate_required([:userid, :teamid, :tag])  #validates one or more fields are present
    |> validate_inclusion(:tag, ["nfl", "nba", "nhl"]) #added if tag != one of these, error will be produced, check for remaining tags that are offered
    #|> unsafe_validate_unique([:tag], Slackproject.Repo) # make sure no duplicates are added to the database
  end

  def validate_required_inclusion(changeset, fields,  options \\ []) do
    if Enum.any?(fields, fn(field) -> get_field(changeset, field) end),
      do: changeset,
      else: add_error(changeset, hd(fields), "One of these fields must be present: #{inspect fields}")
    end
  #this works: Converts tuple to list, then encodes the list!
  defimpl Poison.Encoder, for: Tuple do
    def encode(data, options) when is_tuple(data) do
      data
      |> Tuple.to_list()
      |> Encoder.List.encode(options)
    end
  end
end
