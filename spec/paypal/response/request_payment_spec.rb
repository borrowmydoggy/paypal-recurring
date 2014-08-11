require "spec_helper"

describe PayPal::Recurring::Response::Payment do
  context "when successful" do
    use_vcr_cassette "payment/success"

    subject {
      ppr = PayPal::Recurring.new({
        :description => "Awesome - Monthly Subscription",
        :amount      => "9.00",
        :currency    => "GBP",
        :payer_id    => "D2U7M6PTMJBML",
        :token       => "EC-7DE19186NP195863W",
      })
      ppr.request_payment
    }

    it { should be_valid }
    it { should be_completed }
    it { should be_approved }

    its(:errors) { should be_empty }
    its(:amount) { should ==  '9.00' }
    its(:transaction_id) { should ==  '4CG10595LH1072406' } 
    its(:currency) { should ==  'GBP' }
    its(:paid_at) { should ==  '2012-04-23T04:06:48Z' }
  end

  context 'virtual attributes' do
    before do
      @ipn_description = 'Random description'
      @payer_id = 'D2U7M6PTMJBML22'
      @response = PayPal::Recurring::Response::Payment.new
      @response.ipn_description = 'Random description'
    end

    it 'should set appropriate value to ipn_description' do
      @response.ipn_description = @ipn_description
    end

    it 'should set appropriate value to payer_id' do
      @response.payer_id = @payer_id
    end
  end

  context "when failure" do
    use_vcr_cassette("payment/failure")
    subject { PayPal::Recurring.new.request_payment }

    it { should_not be_valid }
    it { should_not be_completed }
    it { should_not be_approved }

    its(:errors) { should have(2).items }
  end
end
