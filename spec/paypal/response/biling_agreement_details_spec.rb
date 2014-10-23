require "spec_helper"

describe PayPal::Recurring::Response::Details do
  context "when successful" do
    use_vcr_cassette "biling_agreement_details/success"

    subject {
      ppr = PayPal::Recurring.new(:billing_agreement_id => "B-0D277778WT5075231")
      ppr.biling_agreement_details
    }

    it { should be_valid }
    it { should be_success }

    its(:errors) { should be_empty }
    its(:billing_agreement_id) { should == "B-0D277778WT5075231" }
    its(:agreement_status) { should == "Active" }
    its(:active?) { should be_true }
    its(:agreement_description) { should == 'Owner Upgrade Annual Payment' }
    its(:agreement_payer_id) { should == "XWCGJTX97JCD2" }
    its(:agreement_payer_status) { should == "verified" }
  end

  context "cancel the agreement, successful" do
    use_vcr_cassette "biling_agreement_details/success_cancel_agreement"

    subject {
      ppr = PayPal::Recurring.new(
        {
          :billing_agreement_id => "B-0D277778WT5075231", :agreement_status => "Canceled" 
        }
      )
      ppr.biling_agreement_details
    }

    it { should be_valid }
    it { should be_success }

    its(:errors) { should be_empty }
    its(:billing_agreement_id) { should == "B-0D277778WT5075231" }
    its(:agreement_status) { should_not == "Active" }
    its(:active?) { should be_false }
  end

  context "when failure" do
    use_vcr_cassette("biling_agreement_details/failure")
    subject {
      ppr = PayPal::Recurring.new(:billing_agreement_id => "B-0D277778WT5075231")
      ppr.biling_agreement_details
    }

    it { should_not be_valid }
    it { should_not be_success }

    its(:active?) { should be_false }
    its(:errors) { should have(5).items }
  end
end