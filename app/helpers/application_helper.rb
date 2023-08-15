# frozen_string_literal: true

module ApplicationHelper
  # Convert markdown to HTML.
  def markdown(text)
    options = {
      # filter_html: true,
      hard_wrap: true,
      link_attributes: {rel: 'nofollow', target: '_blank'},
      space_after_headers: true,
      fenced_code_blocks: true,
    }

    extensions = {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true,
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def default_meta_tags
    {
      site: 'https://hackerspace.govhack.org/',
      title: 'GovHack Hackerspace',
      reverse: true,
      separator: '|',
      description: 'Hackerspace is GovHack\'s official platform for the competition weekend.',
      keywords: 'govhack, hackathon, open data',
      canonical: request.original_url,
      og: {
        site_name: 'https://hackerspace.govhack.org/',
        title: 'GovHack Hackerspace',
        description: 'Hackerspace is GovHack\'s official platform for the competition weekend.', 
        type: 'website',
        url: request.original_url,
        image: image_url('/assets/bannerlogo.png')
      }
    }
  end
end
