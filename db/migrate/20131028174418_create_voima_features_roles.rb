class CreateVoimaFeaturesRoles < ActiveRecord::Migration
  def change
    create_table :voima_features_roles do |t|
      t.belongs_to :role, index: true
      t.belongs_to :feature, index: true

      t.timestamps
    end
  end
end
