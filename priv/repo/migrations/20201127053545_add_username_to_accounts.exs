defmodule Instagram.Repo.Migrations.AddUsernameToAccounts do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :full_name, :string
      add :image_url, :string
      add :bio, :string
      add :website, :string
    end
  end
end
