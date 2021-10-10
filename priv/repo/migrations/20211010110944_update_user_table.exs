defmodule Pento.Repo.Migrations.UpdateUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :string, default: ""
      add :second_name, :string, default: ""
      add :phone, :string, default: "2547"      
    end
  end
end
