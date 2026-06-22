class CreateAffiliates < ActiveRecord::Migration[7.2]
  def change
    create_table :affiliates do |t|
      t.string  :full_name,     null: false
      t.string  :cpf,           null: false
      t.string  :email,         null: false
      t.string  :whatsapp,      null: false
      t.string  :tiktok,        null: false
      t.string  :instagram,     null: false
      t.string  :zip_code,      null: false
      t.string  :street,        null: false
      t.string  :number,        null: false
      t.string  :complement
      t.string  :neighborhood,  null: false
      t.string  :city,          null: false
      t.string  :state,         null: false
      t.boolean :terms_accepted, null: false, default: false

      t.timestamps
    end

    add_index :affiliates, :cpf,   unique: true
    add_index :affiliates, :email, unique: true
  end
end
