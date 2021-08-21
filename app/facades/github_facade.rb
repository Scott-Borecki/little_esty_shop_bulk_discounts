class GithubFacade
  def self.repository
    repository_data = GithubService.repository

    Github.new(repository_data)
  end

  def self.number_of_commits(user_id)
    return if GithubService.commits.empty?

    user_commit_stats =
      GithubService.commits.find do |contributor_stats|
        user_id == contributor_stats[:author][:id]
      end

    user_commit_stats[:total]
  end

  def self.number_of_pull_requests(user_id)
    GithubService.pull_requests.count do |pull_request|
      user_id == pull_request[:user][:id]
    end
  end
end
