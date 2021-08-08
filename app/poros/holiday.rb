class Holiday
  attr_reader :date,
              :local_name,
              :name,
              :country_code,
              :fixed,
              :global,
              :counties,
              :launch_year,
              :types

  def initialize(attributes)
    @date         = attributes[:date]
    @local_name   = attributes[:localName]
    @name         = attributes[:name]
    @country_code = attributes[:countryCode]
    @fixed        = attributes[:fixed]
    @global       = attributes[:global]
    @counties     = attributes[:counties]
    @launch_year  = attributes[:launchYear]
    @types        = attributes[:types]
  end
end
