class GithubService
  def self.repository
    response = Faraday.get('https://api.github.com/repos/Scott-Borecki/little_esty_shop_bulk_discounts')
    JSON.parse(response.body, symbolize_names: true)
  end
end
