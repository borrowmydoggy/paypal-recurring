module PayPal
  module Recurring
    module Response
      class BillingAgreement < Base
        mapping(
          :billing_agreement_id => :BILLINGAGREEMENTID
        )

        def obtained_billing_agreement?
          !billing_agreement_id.blank?
        end
      end
    end
  end
end