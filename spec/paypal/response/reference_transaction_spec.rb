require "spec_helper"

describe PayPal::Recurring::Response::ReferenceTransaction do
  context "when successful" do
    use_vcr_cassette "reference_transaction/success"

    let(:paypal) {
      PayPal::Recurring.new({
        :token  => "EC-47J551124P900104V",
        :billing_agreement_id => 'B-7FB31251F28061234',
        :custom => 'Some custom value'
      })
    }

    subject { paypal.reference_transaction }

    it { should be_valid }
    its(:agreement_id) { should == "B-7FB31251F28061234" }
    its(:payment_completed?) { should be_true }
    its(:transaction_id) { should == '98A13946GS4491234' }
    its(:errors) { should be_empty }
  end

  context "when failure" do
    use_vcr_cassette("reference_transaction/failure")

    let(:paypal) {
      PayPal::Recurring.new({:token  => "EC-47J551124P900104V"})
    }
    subject { paypal.reference_transaction }

    it { should_not be_valid }
    its(:errors) { should have(5).items }
  end
end