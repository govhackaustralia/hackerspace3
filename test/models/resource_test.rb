# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id                 :bigint           not null, primary key
#  category           :integer
#  name               :string
#  position           :integer
#  short_url          :string
#  show_on_front_page :boolean
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  competition_id     :integer
#
# Indexes
#
#  index_resources_on_show_on_front_page  (show_on_front_page)
#
require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  setup do
    @resource = resources(:one)
    @competition = competitions(:one)
  end

  test 'resources associations' do
    assert_equal @competition, @resource.competition
    assert @resource.visits.include? visits(:resource)

    @resource.destroy!

    assert_raises(ActiveRecord::RecordNotFound) { visits(:resource).reload }
  end

  test 'resources validations presence' do
    %i[category position name url short_url].each do |attribute|
      attributes = {
        category: :data_portal,
        position: 1,
        name: 'New Name',
        url: 'www.new.com',
        short_url: 'new',
      }
      attributes[attribute] = nil
      resource = competitions(:two).resources.new(attributes)
      assert_raises(ActiveRecord::RecordInvalid) { resource.save! }
    end
  end

  test 'scopes' do
    assert Resource.show_on_front_page.include? resources(:information)
    assert Resource.show_on_front_page.exclude? resources(:one)
  end

  test 'resources validations uniqueness' do
    resource_two = resources(:two)
    assert_raises(ActiveRecord::RecordInvalid) do
      @resource.update! name: resource_two.name, category: resource_two.category
    end
  end

  test 'position validation' do
    @competition.resources.data_portal.new(
      position: 1,
      name: 'resource 2',
      url: 'www.resource.2',
      short_url: 'resourcee.2',
    ).save!

    assert_equal 2, @resource.reload.position
  end
end
