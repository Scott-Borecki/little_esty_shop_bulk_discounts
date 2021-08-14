class Github
  attr_reader :repo_name,
              :url

  def initialize(attributes)
    @repo_name = attributes[:name]
    @url       = attributes[:html_url]
  end
end
