defmodule Slackproject.PayloadUser do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Slackproject.IdentificationUser
  alias Slackproject.PayloadUser
  alias Poison.Encoder

  schema "payload" do
    field :message, :string
    field :tag, :string

    timestamps()
  end

  def format(user) do
    %{
      :message => user.message,
      :tag => user.tag
    }
  end

  def all() do
    Repo.all(PayloadUser)
  end

  @doc false
  def changeset(%PayloadUser{} = user, attrs) do
    user
    |> cast(attrs, [:message, :tag])
    |> validate_required([:message, :tag])
    #|> validate_required([:userid, :teamid, :tag])  #validates one or more fields are present
    #|> validate_inclusion(:tag, ["nba", "nfl", "fifa-world-cup", "nhl", "z", "sports", "a"]) #added if tag != one of these, error will be produced, check for remaining tags that are offered
    #|> unsafe_validate_unique([:tag], Slackproject.Repo) # make sure no duplicates are added to the database
  end

    def validate_required_inclusion(changeset, fields,  options \\ []) do
      if Enum.any?(fields, fn(field) -> get_field(changeset, field) end),
        do: changeset,
        else: add_error(changeset, hd(fields), "One of these fields must be present: #{inspect fields}")
      end
    #this works: Converts tuple to list, then encodes the list!
    # defimpl Poison.Encoder, for: Tuple do
    #   def encode(data, options) when is_tuple(data) do
    #     data
    #     |> Tuple.to_list()
    #     |> Encoder.List.encode(options)
    #   end
    # end
end
