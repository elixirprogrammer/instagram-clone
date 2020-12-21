defmodule Instagram.Feed.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :image_url, {:array, :string}, default: []
    field :description, :string
    belongs_to :user, Instagram.Accounts.User


    timestamps()
  end

  @doc false
  def changeset(post, attrs \\ %{}) do
    post
    |> cast(attrs, [:image_url, :description])
    |> validate_required([:image_url])
  end
end
