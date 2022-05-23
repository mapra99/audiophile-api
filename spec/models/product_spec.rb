require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'associations' do
    it { should have_one_attached(:image) }
    it { should belong_to(:category).class_name("ProductCategory") }
  end
end
