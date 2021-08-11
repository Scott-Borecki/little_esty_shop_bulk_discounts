class WelcomeController < ApplicationController
  def index
    @random_merchant = Merchant.all.sample
  end
end
