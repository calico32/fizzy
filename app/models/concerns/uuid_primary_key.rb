module UuidPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid_primary_key
  end

  def self.generate
    # Base 36 UUIDs are a bit more compact; a bit less ugly
    uuid_to_base36(SecureRandom.uuid_v7)
  end

  def self.uuid_to_base36(uuid)
    # Convert standard UUID format to base36 (lowercase), padded to 25 chars
    uuid.delete('-').to_i(16).to_s(36).rjust(25, '0')
  end

  private

  def generate_uuid_primary_key
    return if id.present?
    self.id = UuidPrimaryKey.generate
  end
end
