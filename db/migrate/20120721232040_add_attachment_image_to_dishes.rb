class AddAttachmentImageToDishes < ActiveRecord::Migration
  def self.up
    change_table :dishes do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :dishes, :image
  end
end
