module Sessions
  class OldSessionsRemover
    def call
      deletable_sessions = Session
                           .more_than_one_month_old
                           .with_no_purchase_carts

      deletable_sessions.destroy_all
    end
  end
end
