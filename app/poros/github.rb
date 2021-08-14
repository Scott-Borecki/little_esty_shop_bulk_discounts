class Github
  attr_reader :repo_name,
              :url,
              :owner,
              :owner_id,
              :owner_url

  def initialize(attributes)
    @repo_name = attributes[:name]
    @url       = attributes[:html_url]
    @owner     = attributes[:owner][:login]
    @owner_id  = attributes[:owner][:id]
    @owner_url = attributes[:owner][:html_url]
  end

  def number_of_commits
    GithubFacade.number_of_commits(@owner_id)
  end

  def number_of_pull_requests
    GithubFacade.number_of_pull_requests(@owner_id)
  end
end
