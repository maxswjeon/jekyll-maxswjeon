# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-maxswjeon"
  spec.version       = "0.1.0"
  spec.authors       = ["Sangwan Jeon"]
  spec.email         = ["commits@swjeon.kr"]

  spec.summary       = "Custom jekyll theme for swjeon.dev"
  spec.homepage      = "https://github.com/maxswjeon/jekyll-maxswjeon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_data|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.3"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.8"
  spec.add_runtime_dependency "jekyll-postcss", "~> 0.5"
end
