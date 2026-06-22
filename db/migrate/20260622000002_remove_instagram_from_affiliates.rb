class RemoveInstagramFromAffiliates < ActiveRecord::Migration[7.2]
  def change
    remove_column :affiliates, :instagram, :string
  end
end
