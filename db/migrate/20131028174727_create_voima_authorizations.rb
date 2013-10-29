class CreateVoimaAuthorizations < ActiveRecord::Migration
  def change
    create_table :voima_authorizations do |t|
      t.belongs_to :company, index: true
      t.belongs_to :role, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
