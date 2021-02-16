module ModelSerializer
  extend ActiveSupport::Concern

  included do
    attribute :id
    attribute :created_at
    attribute :updated_at
  end
end