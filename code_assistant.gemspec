# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'code_assistant/version'

Gem::Specification.new do |spec|
  spec.name          = "code_assistant"
  spec.version       = CodeAssistant::VERSION
  spec.authors       = ["Dmitry Boltrushko"]
  spec.email         = ["dboltrushko@cloudnexa.com"]
  spec.description   = %q{Coding and testing routines }
  spec.summary       = %q{Coding and testing routines}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'httparty'
  spec.add_dependency 'sanitize'
  spec.add_dependency 'active_support'
  spec.add_dependency 'i18n'
end
