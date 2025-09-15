class Account < ApplicationRecord
  include Entropic, Joinable

  has_many_attached :uploads

  def slug
    "/#{tenant_id}"
  end

  def setup_basic_template
    user = User.first

    Closure::Reason.create_defaults
    Collection.create!(name: "Cards", creator: user, all_access: true)
    workflow = Workflow.create!(name: "Basic")
    Collection.first.update!(workflow: workflow)
  end
end
