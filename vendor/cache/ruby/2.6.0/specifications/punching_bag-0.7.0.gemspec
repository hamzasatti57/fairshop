# -*- encoding: utf-8 -*-
# stub: punching_bag 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "punching_bag".freeze
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Adam Crownoble".freeze]
  s.date = "2019-12-18"
  s.description = "PunchingBag is a hit counting and simple trending engine for Ruby on Rails".freeze
  s.email = "adam@codenoble.com".freeze
  s.homepage = "https://github.com/biola/punching_bag".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "PunchingBag hit conter and trending plugin".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>.freeze, [">= 3.2"])
      s.add_runtime_dependency(%q<voight_kampff>.freeze, [">= 1.0"])
      s.add_development_dependency(%q<activerecord>.freeze, ["~> 5.2.3"])
      s.add_development_dependency(%q<combustion>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<rspec-its>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.8"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
    else
      s.add_dependency(%q<railties>.freeze, [">= 3.2"])
      s.add_dependency(%q<voight_kampff>.freeze, [">= 1.0"])
      s.add_dependency(%q<activerecord>.freeze, ["~> 5.2.3"])
      s.add_dependency(%q<combustion>.freeze, ["~> 1.1"])
      s.add_dependency(%q<rspec-its>.freeze, ["~> 1.3"])
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.8"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
    end
  else
    s.add_dependency(%q<railties>.freeze, [">= 3.2"])
    s.add_dependency(%q<voight_kampff>.freeze, [">= 1.0"])
    s.add_dependency(%q<activerecord>.freeze, ["~> 5.2.3"])
    s.add_dependency(%q<combustion>.freeze, ["~> 1.1"])
    s.add_dependency(%q<rspec-its>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.8"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
  end
end
