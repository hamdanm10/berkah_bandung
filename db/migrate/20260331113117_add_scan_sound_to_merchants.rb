class AddScanSoundToMerchants < ActiveRecord::Migration[8.1]
  def change
    add_column :merchants, :scan_sound, :string, null: true
  end
end
