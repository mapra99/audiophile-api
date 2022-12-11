# frozen_string_literal: true

if Rails.env.test?
  require 'factory_bot'
  require 'faker'
end

namespace :seeds do
  desc 'Seeds the DB with enough data for E2E tests'
  task e2e: :environment do
    include FactoryBot::Syntax::Methods

    puts 'Running DB Seeds for E2E tests'
    raise StandardError, "You're trying to run this task in a non-test environment" unless Rails.env.test?

    categories = create_list(:product_category, 3)
    create(:featured_product, product_category: categories[0])

    puts 'Finished DB Seeds'
  end
end
