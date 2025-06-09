# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

# activate :autoprefixer do |prefix|
#   prefix.browsers = "last 2 versions"
# end

after_configuration do
  ::Middleman::Renderers::ERb::Template.class_eval do
    # override the existing method in-place
    def precompiled_template(locals)
      super.dup.force_encoding('utf-8')
    end
  end
end

activate :external_pipeline,
  name: :css,
  command: "npx postcss source/stylesheets/tailwind.css -o .tmp/stylesheets/tailwind.css#{" --watch" unless build?}",
  source: ".tmp"

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false


# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript, compressor: Terser.new
# end

configure :development do
  module Rack
    class DowncaseHeaders
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        # Lower-case all header names
        [status, headers.transform_keys(&:downcase), body]
      end
    end
  end
  use Rack::DowncaseHeaders
  activate :livereload, ignore: ["/admin/"]
end


configure :development do
  set :logging, ::Logger::DEBUG
  set :show_exceptions, true
end

# Append a hash to asset urls (make sure to use the url helpers)
configure :build do
  activate :asset_hash do |opts|
    opts.exts = config[:asset_extensions] + %w(.avif .json) - %w(.ico)
  end
end

# ignore 'stylesheets/tailwind.css'
Time.zone = 'Asia/Kolkata'

activate :blog do |blog|
  blog.tag_template = "tag.html"
  blog.layout = "article"        # uses source/layouts/article.erb
  blog.prefix = "articles"
  blog.sources = '{original_year}-{original_month}-{original_day}-{original_title}.html'
end

activate :directory_indexes
set :markdown,
    input:  "GFM",        # use GitHub‑Flavored Markdown parser
    hard_wrap: false       # treat single newlines as <br/>

set :root_url, ENV['URL'] || 'http://localhost:4567'

tags = resources
        .select {it.data.tags}
        .map {it.data.tags}
        .map { it.is_a?(String) ? it.split(',').map(&:strip) : it }
        .flatten
        .sort_by(&:downcase)
        .uniq

collection :sorted_tags, tags

