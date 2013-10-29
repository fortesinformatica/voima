class CreateVoimaRoles < ActiveRecord::Migration
  def change
    create_table :voima_roles do |t|
      t.string :name
      t.belongs_to :organization, index: true

      t.timestamps
    end
  end
end
