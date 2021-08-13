class Github
  attr_reader :repo_name

  def initialize(attributes)
    @repo_name = attributes[:name]
  end
end
