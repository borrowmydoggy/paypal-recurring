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
          :currency             => :PAYMENTINFO_0_CURRENCYCODE,
          :paid_at              => :PAYMENTINFO_0_ORDERTIME,
          :reference            => [:PROFILEREFERENCE, :PAYMENTREQUEST_0_CUSTOM, :PAYMENTREQUEST_0_INVNUM]
        )

        attr_accessor :ipn_description, :payer_id, :user_id

        def completed?
          status == "Completed"
        end

        def approved?
          params[:PAYMENTINFO_0_ACK] == "Success"
        end

        def error_and_redirect_back_to_paypal?
          !valid? && params[:L_ERRORCODE0] == "10486"
        end
      end
    end
  end
end
