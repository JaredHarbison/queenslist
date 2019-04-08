class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :admin, default: false
      t.boolean :queen, default: false
      t.string "password_digest"
      t.index ["email"], name: "index_users_on_email", unique: true

      t.timestamps
    end
  end
end
