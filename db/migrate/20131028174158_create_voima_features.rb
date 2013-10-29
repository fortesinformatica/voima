class CreateVoimaFeatures < ActiveRecord::Migration
  def change
    create_table :voima_features do |t|
      t.string :action
      t.string :controller
      t.string :description
      t.boolean :requires_dependent, default: false

      t.timestamps
    end
  end
end
