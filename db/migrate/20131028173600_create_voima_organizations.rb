class CreateVoimaOrganizations < ActiveRecord::Migration
  def change
    create_table :voima_organizations do |t|
      t.string :name

      t.timestamps
    end
  end
end
