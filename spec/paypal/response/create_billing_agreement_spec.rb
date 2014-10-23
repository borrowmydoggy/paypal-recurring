require "spec_helper"

describe PayPal::Recurring::Response::BillingAgreement do
  context "check status, successful" do
    use_vcr_cassette "create_billing_agreement/success"

    let(:paypal) {
      PayPal::Recurring.new({
        :token  => "EC-47J551124P900104V"
      })
    }

    subject { paypal.create_billing_agreement }

    it { should be_valid }
    its(:billing_agreement_id) { should == "B-7FB31251F28061234" }
    its(:errors) { should be_empty }
  end

  context "when failure" do
    use_vcr_cassette("create_billing_agreement/failure")

    let(:paypal) {
      PayPal::Recurring.new({})
    }
    subject { paypal.create_billing_agreement }

    it { should_not be_valid }
    its(:errors) { should have(5).items }
  end
end