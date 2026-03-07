class CreateMediapipe < ActiveRecord::Migration[7.1]
  def up
    create_table :mediapipes, id: :uuid do |t|
      t.string :landmarks

      t.timestamps
    end
  end

  def down
    drop_table :mediapipes
  end
end
