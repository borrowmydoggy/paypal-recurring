module PayPal
  module Recurring
    module Response
      class BillingAgreementDetails < Base
        mapping(
          :billing_agreement_id   => :BILLINGAGREEMENTID,
          :agreement_status       => :BILLINGAGREEMENTSTATUS,
          :agreement_description  => :BILLINGAGREEMENTDESCRIPTION,
          :agreement_payer_id     => :PAYERID,
          :agreement_payer_status => :PAYERSTATUS 
        )

        def active?
          agreement_status == "Active"
        end
      end
    end
  end
end