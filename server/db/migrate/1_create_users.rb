class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :email
      t.string :password
      t.string :auth_token
      t.string :verification_token
      t.string :name
    end
  end
end