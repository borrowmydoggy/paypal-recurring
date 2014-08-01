module PayPal
  module Recurring
    module Response
      class ReferenceTransaction < Base
        mapping(
          :payment_status => :PAYMENTSTATUS,
          :payment_type => :PAYMENTTYPE,
          :transaction_id => :TRANSACTIONID,
          :agreement_id => :BILLINGAGREEMENTID
        )

        def payment_completed?
          params[:payment_status] == 'Completed'
        end

        def payment_instant?
          params[:payment_type] == 'instant'
        end
      end
    end
  end
end