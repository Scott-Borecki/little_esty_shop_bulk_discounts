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
    owner_stats =
      GithubFacade.commits.find do |contributor_stats|
        @owner_id == contributor_stats[:author][:id]
      end

    owner_stats[:total]
  end

  def number_of_pull_requests
    GithubFacade.pull_requests.count do |pull_request|
      @owner_id == pull_request[:user][:id]
    end
  end
end
