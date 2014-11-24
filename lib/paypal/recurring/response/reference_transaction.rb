module PayPal
  module Recurring
    module Response
      class ReferenceTransaction < Base
        mapping(
          payment_status: :PAYMENTSTATUS,
          payment_type: :PAYMENTTYPE,
          transaction_id: :TRANSACTIONID,
          agreement_id: :BILLINGAGREEMENTID,
          amount: :AMT,
          currency: :CURRENCYCODE,
          paid_at: :ORDERTIME
        )

        def payment_completed?
          payment_status == 'Completed'
        end

        def payment_instant?
          payment_type == 'instant'
        end
      end
    end
  end
end