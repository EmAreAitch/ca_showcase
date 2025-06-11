module ApplicationHelpers
  def netlify_image_url(article, fm: "avif", fit: nil, w: nil, h: nil, position: nil, q: nil)
    # fallback image path
    default_image = '/images/default_article_cover.avif'
    cover_image = article.data['cover_image']
    return default_image if cover_image.blank? and development?
    # use image_path helper if available
    image = image_path(cover_image.present? ? cover_image : default_image)

    query_params = {fm:, fit:, w:, h:, position:, q:, url: image}.compact


    "/.netlify/images?#{query_params.to_query}"
  end
end
