# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

# activate :autoprefixer do |prefix| 
#   prefix.browsers = "last 2 versions"
# end


class Middleman::Renderers::ERb::Template
  # override the existing method in-plac
  def precompiled_template(locals)
    super.dup.force_encoding('utf-8')
  end
end
module Middleman::Blog::UriTemplates
  def self.safe_parameterize(str, sep = '-')
    # ← your custom logic here, for example:
    str.to_slug.normalize.to_s
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

# configure :development do
  # set :logging, ::Logger::DEBUG
  # set :show_exceptions, true
# end

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
  blog.sources = '{original_slug}.html'
  blog.paginate = true
  blog.per_page = 3
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

