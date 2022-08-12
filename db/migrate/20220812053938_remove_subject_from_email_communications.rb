class RemoveSubjectFromEmailCommunications < ActiveRecord::Migration[6.1]
  def up
    remove_column :email_communications, :subject
  end

  def down
    add_column :email_communications, :subject, :string, null: false
  end
end
