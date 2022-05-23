module Validators
  class ContentValueValidator < ActiveModel::Validator
    def validate(record)
      @record = record

      record.errors.add :value, 'Either value or files must be provided' if value_and_files_blank?
      record.errors.add :value, 'Only one of value or files must be provided' if value_and_files_present?
    end

    private

    attr_reader :record

    def value_and_files_present?
      record.files.present? && record.value.present?
    end

    def value_and_files_blank?
      record.files.blank? && record.value.blank?
    end
  end
end
