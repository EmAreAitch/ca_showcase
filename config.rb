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

# config.rb
activate :external_pipeline,
  name: :css,
  command: build? ?
    "npx postcss source/stylesheets/tailwind.css -o build/stylesheets/tailwind.css" :
    "npx postcss source/stylesheets/tailwind.css -o .tmp/stylesheets/tailwind.css --watch",
  source: (build? ? "build" : ".tmp")


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


configure :build do
  # Append a hash to asset urls (make sure to use the url helpers)
  activate :asset_hash do |opts|
    opts.exts = config[:asset_extensions] + %w(.avif) - %w(.ico)
    opts.ignore += [%r{^images/uploads/}]
  end
end

# ignore 'stylesheets/tailwind.css'
Time.zone = 'Asia/Kolkata'

activate :blog do |blog|
  # Store source files under source/articles
  blog.sources = "articles/{year}-{month}-{day}-{title}.html"
  # URLs will be /articles/YYYY/MM/DD/title.html
  blog.permalink = "articles/{year}/{month}/{day}/{title}.html"
  # Use markdown files by default
  blog.default_extension = ".markdown"
  # Optional: customize layouts
  blog.tag_template = "tag.html"
  blog.layout = "article"        # uses source/layouts/article.erb
  blog.taglink = "articles/tags/{tag}.html"
  blog.year_link = "articles/{year}.html"
  blog.month_link = "articles/{year}/{month}.html"
  blog.day_link = "articles/{year}/{month}/{day}.html"
  # Enable pagination if desired
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

activate :directory_indexes
set :markdown,
    input:  "GFM",        # use GitHub‑Flavored Markdown parser
    hard_wrap: false       # treat single newlines as <br/>
