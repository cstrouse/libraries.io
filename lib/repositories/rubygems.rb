class Repositories
  class Rubygems < Base
    HAS_VERSIONS = true

    def self.project_names
      gems = Marshal.load(Gem.gunzip(HTTParty.get("http://production.cf.rubygems.org/specs.4.8.gz").parsed_response))
      gems.map(&:first).uniq
    end

    def self.project(name)
      Gems.info name
    end

    def self.mapping(project)
      {
        :name => project["name"],
        :description => project["info"],
        :homepage => project["homepage_uri"],
        :licenses => project["licenses"].join(',')#,
        # :repository => project["source_code_uri"]
      }
    end

    def self.versions(project)
      Gems.versions(project['name']).map do |v|
        {
          :number => v['number'],
          :published_at => v['built_at']
        }
      end
    end
  end
end
