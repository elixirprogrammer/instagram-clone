defmodule Instagram.Repo.Migrations.AlterImageUrl do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :image_url
      add :image_url, {:array, :string}, null: false, default: []
    end
  end
end
