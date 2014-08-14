module PayPal
  module Recurring
    module Response
      class BillingAgreementDetails < Base
        mapping(
          :billing_agreement_id => :BILLINGAGREEMENTID
        )
      end
    end
  end
end