class Storage::Entry < ApplicationRecord
  belongs_to :account
  belongs_to :board, optional: true
  belongs_to :recordable, polymorphic: true, optional: true

  scope :pending, ->(last_entry_id) { where.not(id: ..last_entry_id) if last_entry_id }

  # Accepts either objects or _id params (for after_destroy_commit snapshots).
  # ID-only params exist because record_storage_detach passes snapshotted IDs when
  # parent is deleted. Must preserve audit context even when objects are gone.
  def self.record(delta:, operation:, account: nil, account_id: nil, board: nil, board_id: nil,
                   recordable: nil, recordable_type: nil, recordable_id: nil, blob: nil, blob_id: nil)
    return if delta.zero?

    account_for_job = resolve_for_job(account, account_id, Account)
    board_for_job = resolve_for_job(board, board_id, Board)

    entry = create! \
      account_id: account_for_job&.id || account_id,
      board_id: board_for_job&.id || board_id,
      recordable_type: recordable_type || recordable&.class&.name,
      recordable_id: recordable_id || recordable&.id,
      blob_id: blob&.id || blob_id,
      delta: delta,
      operation: operation,
      user_id: Current.user&.id,
      request_id: Current.request_id

    account_for_job&.materialize_storage_later
    board_for_job&.materialize_storage_later

    entry
  end

  # Use object directly when available and not destroyed.
  # During cascading deletes, the object may exist in memory but be destroyed in DB.
  def self.resolve_for_job(object, id, klass)
    if object.is_a?(klass) && !object.destroyed?
      object
    else
      id && klass.find_by(id: id)
    end
  end
end
