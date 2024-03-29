require 'find'
require 'json'
require 'pathname'

namespace :bower do

  find_files = ->(path) {
    Find.find(Pathname.new(path).relative_path_from(Pathname.new Dir.pwd).to_s).map do |path|
      path if File.file?(path)
    end.compact
  }

  desc 'update main and version in bower.json'
  task :generate do
    require 'sq-bootstrap-sass'
    Dir.chdir SqBootstrap.gem_path do
      spec       = JSON.parse(File.read 'bower.json')

      spec['main'] =
          find_files.(File.join(SqBootstrap.stylesheets_path, '_sq-bootstrap.scss')) +
          find_files.(SqBootstrap.fonts_path) +
          %w(assets/javascripts/sq-bootstrap.js)

      spec['version'] = SqBootstrap::VERSION

      File.open('bower.json', 'w') do |f|
        f.puts JSON.pretty_generate(spec)
      end
    end
  end
end
