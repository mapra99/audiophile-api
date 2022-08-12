class CreateVerificationCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :verification_codes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code_digest, null: false
      t.string :status, null: false
      t.datetime :expires_at, null: false
      t.string :expiration_job_id

      t.timestamps
    end
  end
end
