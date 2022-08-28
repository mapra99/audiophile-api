class AddUserIdToSessions < ActiveRecord::Migration[6.1]
  def change
    add_reference :sessions, :user, foreign_key: true
  end
end
