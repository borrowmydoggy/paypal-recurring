module PayPal
  module Recurring
    module Response
      class Payment < Base
        mapping(
          :status               => :PAYMENTINFO_0_PAYMENTSTATUS,
          :amount               => :PAYMENTINFO_0_AMT,
          :fees                 => :PAYMENTINFO_0_FEEAMT,
          :transaction_id       => :PAYMENTINFO_0_TRANSACTIONID,
          :seller_id            => :PAYMENTINFO_0_SECUREMERCHANTACCOUNTID,
          :billing_agreement_id => :BILLINGAGREEMENTID,
          :reference            => [:PROFILEREFERENCE, :PAYMENTREQUEST_0_CUSTOM, :PAYMENTREQUEST_0_INVNUM]
        )

        def completed?
          status == "Completed"
        end

        def approved?
          params[:PAYMENTINFO_0_ACK] == "Success"
        end
      end
    end
  end
end
