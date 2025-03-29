# frozen_string_literal: true

ActionText::ContentHelper.allowed_tags = %w[
  a abbr b blockquote br cite code dd div dl dt em h1 h2 h3 h4 h5 h6
  i img li ol p pre small span strong sub sup table tbody td tfoot th
  thead tr u ul
]

ActionText::ContentHelper.allowed_attributes = %w[
  href src alt title class id data-* style
]