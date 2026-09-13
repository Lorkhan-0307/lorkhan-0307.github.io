# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem 'csv'
gem 'base64'


gem 'jekyll-target-blank'

group :test do
  gem "html-proofer", "~> 5.0"
end

gem "webrick", "~> 1.8"

# Windows does not provide the IANA timezone database used by Jekyll.
platforms :mingw, :x64_mingw, :mswin do
  gem "tzinfo", "~> 2.0"
  gem "tzinfo-data"
end
