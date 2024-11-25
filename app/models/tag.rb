class Tag < ApplicationRecord
  include Filterable

  belongs_to :account, default: -> { Current.account }

  has_many :taggings, dependent: :destroy
  has_many :bubbles, through: :taggings

  def hashtag
    "#" + title
  end

  def to_combobox_display
    title
  end
end
