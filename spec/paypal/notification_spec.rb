require "spec_helper"

describe PayPal::Recurring::Notification do
  it "detects express checkout" do
    subject.params[:txn_type] = "express_checkout"
    subject.should be_express_checkout
  end

  it "detects recurring payment" do
    subject.params[:txn_type] = "recurring_payment"
    subject.should be_recurring_payment
  end

  it "detects recurring payment profile" do
    subject.params[:txn_type] = "recurring_payment_profile_created"
    subject.should be_recurring_payment_profile
  end

  it "detects echeck payment" do
    subject.params[:txn_type] = "echeck"
    subject.should be_echeck
  end

  it "normalizes payment date" do
    subject.params[:payment_date] = "20:37:06 Jul 04, 2011 PDT" # PDT = -0700
    subject.paid_at.strftime("%Y-%m-%d %H:%M:%S").should == "2011-07-05 03:37:06"
  end

  it "normalizes creation date" do
    subject.params[:time_created] = "20:37:06 Jul 04, 2011 PDT" # PDT = -0700
    subject.created_at.strftime("%Y-%m-%d %H:%M:%S").should == "2011-07-05 03:37:06"
  end

  it "returns currency" do
    subject.params[:mc_currency] = "BRL"
    subject.currency.should == "BRL"
  end

  describe "#payment_date" do
    it "returns date from payment_date field" do
      subject.params[:payment_date] = "2011-07-05"
      subject.payment_date.should == "2011-07-05"
    end
  end

  describe "#fee" do
    it "returns fee from mc_fee field" do
      subject.params[:mc_fee] = "0.56"
      subject.fee.should == "0.56"
    end

    it "returns fee from payment_fee field" do
      subject.params[:payment_fee] = "0.56"
      subject.fee.should == "0.56"
    end
  end

  describe "#amount" do
    it "returns amount from amount field" do
      subject.params[:amount] = "9.00"
      subject.amount.should == "9.00"
    end

    it "returns amount from mc_gross field" do
      subject.params[:mc_gross] = "9.00"
      subject.amount.should == "9.00"
    end

    it "returns amount from payment_gross field" do
      subject.params[:payment_gross] = "9.00"
      subject.amount.should == "9.00"
    end
  end

  describe "#reference" do
    it "returns from recurring IPN" do
      subject.params[:rp_invoice_id] = "abc"
      subject.reference.should == "abc"
    end

    it "returns from custom field" do
      subject.params[:custom] = "abc"
      subject.reference.should == "abc"
    end

    it "returns from invoice field" do
      subject.params[:invoice] = "abc"
      subject.reference.should == "abc"
    end

    it "returns from invoice field" do
      subject.params[:mp_custom] = "abc11"
      subject.custom.should == "abc11"
    end
  end

  describe "#description" do
    it "returns from reference transaction" do
      subject.params[:mp_desc] = "abc33"
      subject.ipn_description.should == "abc33"
    end

    it "returns from normal transactions" do
      subject.params[:transaction_subject] = "abc22"
      subject.ipn_description.should == "abc22"
    end
  end

  context "when successful" do
    use_vcr_cassette "notification/success"

    it "verifies notification" do
      subject.params = {"test_ipn"=>"1", "payment_type"=>"echeck", "payment_date"=>"06:16:11 Jun 27, 2011 PDT", "payment_status"=>"Completed", "pending_reason"=>"echeck", "address_status"=>"confirmed", "payer_status"=>"verified", "first_name"=>"John", "last_name"=>"Smith", "payer_email"=>"buyer@paypalsandbox.com", "payer_id"=>"TESTBUYERID01", "address_name"=>"John Smith", "address_country"=>"United States", "address_country_code"=>"US", "address_zip"=>"95131", "address_state"=>"CA", "address_city"=>"San Jose", "address_street"=>"123, any street", "business"=>"seller@paypalsandbox.com", "receiver_email"=>"seller@paypalsandbox.com", "receiver_id"=>"TESTSELLERID1", "residence_country"=>"US", "item_name"=>"something", "item_number"=>"AK-1234", "quantity"=>"1", "shipping"=>"3.04", "tax"=>"2.02", "mc_currency"=>"USD", "mc_fee"=>"0.44", "mc_gross"=>"12.34", "txn_type"=>"web_accept", "txn_id"=>"116271316", "notify_version"=>"2.1", "custom"=>"xyz123", "invoice"=>"abc1234", "charset"=>"windows-1252", "verify_sign"=>"A12AYqq6LElPcpXaQx48GiroLHnMAoQPnK0Z7aRwXUOpg1GfDaE15mFN"}
      subject.should be_verified
      subject.should be_completed
    end
  end

  context "when failure" do
    use_vcr_cassette "notification/failure"

    it "verifies notification" do
      subject.params = {}
      subject.should_not be_verified
      subject.should_not be_completed
    end
  end

  context 'real world example' do
    before do
      @paypal_ipn = {:mp_custom=>"", :mc_gross=>"35.00", :mp_currency=>"GBP", :protection_eligibility=>"Ineligible", :payer_id=>"4U7G75QGJPPCN", :tax=>"0.00", :payment_date=>"19:48:56 Aug 04, 2014 PDT", :mp_id=>"B-87268697VA547281V", :payment_status=>"Completed", :charset=>"windows-1252", :first_name=>"Eli", :mp_status=>"0", :mc_fee=>"1.39", :notify_version=>"3.8", :custom=>"Upgrade Payment for user: 44963", :payer_status=>"verified", :business=>"tech+sandbox@borrowmydoggy.com", :quantity=>"1", :verify_sign=>"AjNG4H.j9XP5JDmRSY54-UnKMFtBAuED8FGdcr2kEFOC3RwwOV7K2GlZ", :payer_email=>"eli.ingles@hotmail.com", :txn_id=>"43N21400HN680692E", :payment_type=>"instant", :last_name=>"Ingles", :mp_desc=>"Owner Upgrade Annual Payment", :receiver_email=>"tech+sandbox@borrowmydoggy.com", :payment_fee=>"", :mp_cycle_start=>"5", :receiver_id=>"AUAERZW9EQ2GG", :txn_type=>"merch_pmt", :item_name=>"", :mc_currency=>"GBP", :item_number=>"", :residence_country=>"GB", :test_ipn=>"1", :handling_amount=>"0.00", :transaction_subject=>"", :payment_gross=>"", :shipping=>"0.00", :ipn_track_id=>"2f0391f4638af"}
      @new_notifcation = PayPal::Recurring::Notification.new(@paypal_ipn)
    end

    it 'should have description' do
      @new_notifcation.ipn_description.should_not be_nil
      @new_notifcation.ipn_description.should == @paypal_ipn[:mp_desc]
    end

    it 'should have custom' do
      @new_notifcation.custom.should_not be_nil
      @new_notifcation.custom.should == @paypal_ipn[:custom]
    end
  end
end
