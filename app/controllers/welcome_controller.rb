class WelcomeController < ApplicationController
  def index
    @random_merchant = Merchant.all.sample
    @repository      = GithubFacade.repository
  end
end
