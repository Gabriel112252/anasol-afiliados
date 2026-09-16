class AddTermsAcceptedAtToAffiliates < ActiveRecord::Migration[7.2]
  def up
    add_column :affiliates, :terms_accepted_at, :datetime

    execute <<~SQL
      UPDATE affiliates
      SET terms_accepted_at = created_at
      WHERE terms_accepted = TRUE
    SQL
  end

  def down
    remove_column :affiliates, :terms_accepted_at
  end
end
