class CreateJoinTableEventUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :events, :users do |t|
      t.index :event_id
      t.index :user_id
    end
  end
end
