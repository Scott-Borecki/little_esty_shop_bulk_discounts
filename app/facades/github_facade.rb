class GithubFacade
  def self.repository_name
    repository_data = GithubService.repository
    repository_data[:name]
  end
end
