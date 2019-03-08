require 'rails_helper'

RSpec.describe Py3oFusion do
  subject {
    described_class.new(template)
      .data(data)
      .static_image("test_image", image)
  }

  after(:each) do
    generated_pdf.unlink
    template.unlink
    image.unlink
  end

  let(:generated_pdf) { Tempfile.new('output.pdf') }
  let(:template) { Tempfile.new('template.odt') }
  let(:image) { Tempfile.new('image.png') }
  let(:data) do
    {
      foo: "bar"
    }
  end
  let(:response) { instance_double(HTTParty::Response, body: response_body, code: 200) }
  let(:response_body) { 'foo bar baz' }

  context '#generate_pdf' do
    it "posts data to Py3o.Fusion endpoint" do
      expect(HTTParty).to receive(:post) do |endpoint, payload|
        expect(payload[:body]).to include(
          targetformat: "pdf",
          datadict: data.to_json,
          image_mapping: {
            test_image: "staticimage.test_image"
          }.to_json
        )
        expect(payload[:body]).to have_key(:tmpl_file)
        expect(payload[:body]).to have_key(:test_image)
      end.and_return(response)
      subject.generate_pdf(generated_pdf.path)
      generated_pdf.rewind
      expect(generated_pdf.read).to eq 'foo bar baz'
    end
  end
end
