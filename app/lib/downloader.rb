require 'open-uri'

class Downloader
  def initialize(url)
    @url = url
  end

  def get
    begin
      stream = open(@url, 'rb')
      Tempfile.new('download').tap do |tempfile|
        tempfile.binmode
        IO.copy_stream(stream, tempfile)
        stream.close
        tempfile.rewind
      end
    rescue Errno::ENOENT
      nil
    end
  end
end
