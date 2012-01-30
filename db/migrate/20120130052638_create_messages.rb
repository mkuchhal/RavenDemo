class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :messagetext
      t.float :latitude
      t.float :longitude
      t.string :sendername
      t.string :recipientname
      t.datetime :sentat

      t.timestamps
    end
  end
end
