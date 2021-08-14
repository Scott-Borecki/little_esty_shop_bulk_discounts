class GithubService
  def self.repository
    url      = 'https://api.github.com/repos/Scott-Borecki/little_esty_shop_bulk_discounts'
    response = Faraday.get(url).body

    JSON.parse(response, symbolize_names: true)
  end

  # API Info: https://docs.github.com/en/rest/reference/repos#get-all-contributor-commit-activity
  def self.commits
    url      = 'https://api.github.com/repos/Scott-Borecki/little_esty_shop_bulk_discounts/stats/contributors'
    response = Faraday.get(url).body

    JSON.parse(response, symbolize_names: true)
  end

  # API Info: https://docs.github.com/en/rest/reference/pulls
  def self.pull_requests
    url      = 'https://api.github.com/repos/Scott-Borecki/little_esty_shop_bulk_discounts/pulls?state=all'
    response = Faraday.get(url).body

    JSON.parse(response, symbolize_names: true)
  end
end
