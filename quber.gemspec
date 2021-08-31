require_relative 'lib/quber/version'

Gem::Specification.new do |spec|
  spec.name          = 'quber'
  spec.version       = Quber::VERSION
  spec.authors       = ["creadone"]
  spec.email         = ["creadone@gmail.com"]

  spec.summary       = %q{Rails adapter for Qube}
  spec.description   = %q{Rails adapter for Qube}
  spec.homepage      = "https://github.com/roleus/quber"
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7")

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tnt-qube/quber"

  spec.add_runtime_dependency 'net-http-persistent', '~> 3.1.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end