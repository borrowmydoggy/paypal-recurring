module PayPal
  module Recurring
    module Response
      class BillingAgreement < Base
        mapping(
          :agreement_id => :BILLINGAGREEMENTID
        )

        def obtained_billing_agreement?
          !params[:BILLINGAGREEMENTID].blank?
        end
      end
    end
  end
end