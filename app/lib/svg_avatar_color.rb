class SvgAvatarColor
  # Colors from: http://tools.medialab.sciences-po.fr/iwanthue/index.php
  PALETTE = [
    "#c1b468",
    "#7d74e1",
    "#adbc3c",
    "#422c7b",
    "#8bc151",
    "#933e9d",
    "#46ca79",
    "#d871d2",
    "#5cb455",
    "#c751a1",
    "#4cbe84",
    "#cb3863",
    "#1fe1fb",
    "#6e0e09",
    "#3edbd8",
    "#d94d4d",
    "#43c29e",
    "#c34587",
    "#64891c",
    "#5252ab",
    "#c5a02c",
    "#5488e3",
    "#da8829",
    "#588bcf",
    "#bf591f",
    "#a183d9",
    "#40711b",
    "#d196e2",
    "#255719",
    "#e1578a",
    "#7cbf76",
    "#7e276e",
    "#bbbe59",
    "#8c559d",
    "#9fc069",
    "#792050",
    "#3a8142",
    "#d94b5e",
    "#908a29",
    "#d883c4",
    "#797a2e",
    "#a53460",
    "#d8b058",
    "#791f34",
    "#e49149",
    "#d678a4",
    "#99751e",
    "#a73952",
    "#d1995c",
    "#6d0f1a",
    "#ed8b5e",
    "#732c11",
    "#db6f81",
    "#7c5416",
    "#ae2d41",
    "#b46c23",
    "#963237",
    "#e18167",
    "#962623",
    "#e07171",
    "#9e3519",
    "#aa612f",
    "#db5f42",
    "#a9503a"
  ].freeze

  def initialize(string)
    @string = string
  end

  def digest
    Digest::MD5.hexdigest(@string)
  end

  def color
    PALETTE[ digest[0...15].to_i(16) % PALETTE.length ]
  end

  def self.rgb_to_hex(rgb)
    "#" + rgb.map { |component| component.to_s(16).rjust(2, '0') }.join
  end
end
