$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "voima/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "voima"
  s.version     = Voima::VERSION
  s.authors     = ["Equipe NEL"]
  s.email       = ["desenvolvimento.nel@grupofortes.com.br"]
  s.homepage    = ""
  s.summary     = "Summary of Voima."
  s.description = "Description of Voima."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "sqlite3"
end
