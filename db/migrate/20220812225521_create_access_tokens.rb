class CreateAccessTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :access_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.references :verification_code, null: false, foreign_key: true
      t.string :token, null: false
      t.string :status, null: false
      t.datetime :expires_at, null: false
      t.string :expiration_job_id

      t.timestamps
    end

    add_index :access_tokens, :token, unique: true
  end
end
