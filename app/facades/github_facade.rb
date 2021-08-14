class GithubFacade
  def self.repository
    repository_data = GithubService.repository

    Github.new(repository_data)
  end

  def self.commits
    GithubService.commits
  end
end
