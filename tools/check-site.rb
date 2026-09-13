# frozen_string_literal: true

# Validate generated files, including case-sensitive paths on Windows.
# Run after `bundle exec jekyll build`: bundle exec ruby tools/check-site.rb
require 'json'
require 'nokogiri'
require 'pathname'
require 'uri'
require 'addressable/uri'
require 'yaml'
require 'date'

root = Pathname.new(ARGV.fetch(0, '_site')).expand_path
abort "Build the site first: #{root} is missing" unless root.directory?
files = Dir.glob("#{root}/**/*").select { |path| File.file?(path) }
relative_files = files.map { |path| Pathname.new(path).relative_path_from(root).to_s.tr('\\', '/') }
known_files = relative_files.to_h { |path| [path, true] }
config = YAML.unsafe_load_file('_config.yml')
host = URI(config.fetch('url')).host
baseurl = config.fetch('baseurl', '').to_s.delete_suffix('/')
errors = []
documents = {}

relative_files.grep(/\.html$/).each do |path|
  documents[path] = Nokogiri::HTML(File.read(root.join(path), encoding: 'UTF-8'))
end

documents.each do |path, doc|
  doc.css('[href], [src], [data-src]').each do |node|
    %w[href src data-src].each do |attribute|
      value = node[attribute]
      next if value.nil? || value.empty?
      next if value.match?(/\A(?:javascript|mailto|tel|data):/i)
      begin
        uri = Addressable::URI.join("https://#{host}/#{path}", value).normalize
        next unless %w[http https].include?(uri.scheme) && uri.host == host
        target = URI::DEFAULT_PARSER.unescape(uri.path)
        target = target.delete_prefix(baseurl) unless baseurl.empty?
        target = target.delete_prefix('/')
        target = "#{target}index.html" if target.empty? || target.end_with?('/')
        target = "#{target}/index.html" if !known_files[target] && known_files["#{target}/index.html"]
        unless known_files[target]
          errors << "#{path}: missing #{attribute}=#{value}"
          next
        end
        fragment = uri.fragment && URI::DEFAULT_PARSER.unescape(uri.fragment)
        next if fragment.nil? || fragment.empty? || fragment.start_with?(':~:text=')
        target_doc = documents[target]
        next unless target_doc
        unless target_doc.css('[id], a[name]').any? { |item| item['id'] == fragment || item['name'] == fragment }
          errors << "#{path}: missing anchor #{value}"
        end
      rescue URI::InvalidURIError, Addressable::URI::InvalidURIError => e
        errors << "#{path}: invalid URL #{value}: #{e.message}"
      end
    end
  end
end

%w[assets/js/data/search.json assets/img/favicons/site.webmanifest].each do |path|
  begin
    JSON.parse(File.read(root.join(path), encoding: 'UTF-8'))
  rescue JSON::ParserError => e
    errors << "#{path}: #{e.message}"
  end
end

%w[feed.xml sitemap.xml].each do |path|
  begin
    Nokogiri::XML(File.read(root.join(path))) { |options| options.strict }
  rescue Nokogiri::XML::SyntaxError => e
    errors << "#{path}: #{e.message}"
  end
end

# Jekyll warns but succeeds when distinct tags overwrite the same archive.
require 'jekyll'
taxonomies = Hash.new { |hash, key| hash[key] = [] }
Dir.glob('_posts/*.{md,markdown}').each do |path|
  front = File.read(path, encoding: 'UTF-8').split(/^---\s*$/, 3)[1]
  data = YAML.unsafe_load(front)
  if File.read(path).match?(/^```mermaid\s*$/) && data['mermaid'] != true
    errors << "#{path}: Mermaid diagram is missing mermaid: true"
  end
  %w[tags categories].each do |key|
    values = data[key]
    values = values.split if values.is_a?(String)
    Array(values).each { |value| taxonomies[[key, Jekyll::Utils.slugify(value)]] << value }
  end
end
taxonomies.each do |key, values|
  errors << "Archive collision #{key.join('/')}: #{values.uniq.join(', ')}" if values.uniq.length > 1
end

puts "Checked #{documents.size} HTML pages, internal links and anchors, JSON, XML, and archive names."
abort errors.uniq.join("\n") unless errors.empty?
puts 'Site checks passed.'
