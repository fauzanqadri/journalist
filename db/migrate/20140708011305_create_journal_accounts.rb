class CreateJournalAccounts < ActiveRecord::Migration
  def change
    create_table :journal_accounts do |t|
      t.string :username, null: false, default: ""
      t.string :password, null: false, defaulf: ""
      t.string :other, null: false, default: ""
      t.boolean :enable, null: false, default: false
      t.string :status, null: false, default: "offline"
      t.integer :journal_id, null: false
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
