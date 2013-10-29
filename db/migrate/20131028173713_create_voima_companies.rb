class CreateVoimaCompanies < ActiveRecord::Migration
  def change
    create_table :voima_companies do |t|
      t.belongs_to :organization, index: true
      t.string :name

      t.timestamps
    end
  end
end
