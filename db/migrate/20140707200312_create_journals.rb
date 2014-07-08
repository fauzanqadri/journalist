class CreateJournals < ActiveRecord::Migration
  def change
    create_table :journals do |t|
      t.string :name, null: false, default: ""
      t.string :driver, null: false, default: ""
      t.integer :lock_version, null: false, default: 0
      t.integer :journal_accounts_count, null: false, default: 0
      t.integer :online_accounts_count, null: false, default: 0
      t.integer :offline_account_counts, null: false, default: 0
      t.timestamps
    end
  end
end
