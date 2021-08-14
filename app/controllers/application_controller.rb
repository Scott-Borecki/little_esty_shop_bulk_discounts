class ApplicationController < ActionController::Base
  before_action :fetch_repository

  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end

  def fetch_repository
    @repository = GithubFacade.repository
  end
end
