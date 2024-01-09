class AddSmsSupportForVerificationCodes < ActiveRecord::Migration[6.1]
  def up
    change_column_null :verification_codes, :code_digest, true
    add_column :verification_codes, :channel, :string

    VerificationCode.all.each do |code|
      code.update(channel: VerificationCode::EMAIL_CHANNEL)
    end

    change_column_null :verification_codes, :channel, false
  end

  def down
    change_column_null :verification_codes, :code_digest, false
    remove_column :verification_codes, :channel
  end
end
