require 'rails_helper'

RSpec.describe ProductContent, type: :model do
  subject { build(:text_product_content) }

  describe 'associations' do
    it { is_expected.to have_many_attached(:files) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:product_id) }

    describe 'when content is textual and file is also provided' do
      subject(:text_content) { build(:text_product_content) }

      before do
        text_content.files = [Rack::Test::UploadedFile.new('spec/files/product_image.png', 'image/png')]
      end

      it { expect(text_content.valid?).to eq(false) }
    end

    describe 'when content is an attachment and text is also provided' do
      subject(:attachment_content) { build(:attachment_product_content) }

      before do
        attachment_content.value = Faker::Lorem.sentence
      end

      it { expect(attachment_content.valid?).to eq(false) }
    end
  end
end
