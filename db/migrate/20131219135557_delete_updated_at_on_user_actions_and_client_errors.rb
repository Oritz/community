class DeleteUpdatedAtOnUserActionsAndClientErrors < ActiveRecord::Migration
  def up
    remove_column :client_errors, :updated_at
    remove_column :user_actions, :updated_at
  end

  def down
    add_column :client_errors, :updated_at, :datetime
    add_column :user_actions, :updated_at, :datetime
  end
end
