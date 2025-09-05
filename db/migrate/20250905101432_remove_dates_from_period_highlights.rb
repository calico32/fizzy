class RemoveDatesFromPeriodHighlights < ActiveRecord::Migration[8.1]
  def change
    remove_column :period_highlights, :starts_at
    remove_column :period_highlights, :duration
  end
end
