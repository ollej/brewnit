#!/usr/bin/env ruby
require 'rubygems'
require 'py3o_fusion'

data = {
  'item': {
      'beername': 'Cryzilla',
      'description': 'En New England IPA med cryohops, Denali och Citra.',
      'abv': '6.0%',
      'ibu': '55',
      'ebc': '10',
      'bottledate': '2019-02-04',
      'bottlesize': '50 cl'
  }
}
image = File.open('logo.png')

Py3oFusion.new(ENV.fetch('PY3OFUSION_ENDPOINT'))
  .template("files/label_template.odt")
  .data(data)
  .static_image("logo1", image)
  .static_image("logo2", image)
  .static_image("logo3", image)
  .static_image("logo4", image)
  .static_image("logo5", image)
  .static_image("logo6", image)
  .static_image("logo7", image)
  .static_image("logo8", image)
  .static_image("logo9", image)
  .static_image("qrcode1", image)
  .static_image("qrcode2", image)
  .static_image("qrcode3", image)
  .static_image("qrcode4", image)
  .static_image("qrcode5", image)
  .static_image("qrcode6", image)
  .static_image("qrcode7", image)
  .static_image("qrcode8", image)
  .static_image("qrcode9", image)
  .generate_pdf('output.pdf')

