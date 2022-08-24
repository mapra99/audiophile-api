module Validators
  class PurchaseCartStatusValidator < ActiveModel::Validator
    def validate(record)
      @record = record

      record.errors.add :status, 'Session already has a started purchase cart' if started_cart_present?
    end

    private

    attr_reader :record

    def started_cart_present?
      session = record.session
      return if session.blank?

      session.purchase_carts.where.not(id: record.id).started.present?
    end
  end
end
