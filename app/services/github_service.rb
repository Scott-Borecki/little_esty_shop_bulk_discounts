class GithubService
  def self.repository
    url      = 'https://api.github.com/repos/Scott-Borecki/little_esty_shop_bulk_discounts'
    response = Faraday.get(url).body

    JSON.parse(response, symbolize_names: true)
  end
end
