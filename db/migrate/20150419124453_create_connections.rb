class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :provider, null: false, default: ""
      t.string :uid, null: false, default: ""
      t.string :access_token, null: false, default: ""
      t.string :secret
      t.timestamp :expires_at

      t.timestamps null: false
    end

    add_index :connections, [:provider, :uid], unique: true
  end
end
