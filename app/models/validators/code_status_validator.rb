module Validators
  class CodeStatusValidator < ActiveModel::Validator
    def validate(record)
      @record = record

      record.errors.add :status, 'User already has a code with "started" status' if active_code_present?
    end

    private

    attr_reader :record

    def active_code_present?
      user = record.user
      return if user.blank?

      user.verification_codes.where.not(id: record.id).started.present?
    end
  end
end
