class CreateCampaigns < ActiveRecord::Migration[5.2]

  def change
    create_table :campaigns do |t|
      t.string   :title
      t.text     :description
      t.datetime :event_date
      t.string   :event_hour
      t.string   :location
      t.integer  :status

      t.references :user, foreign_key: true

      t.timestamps
    end
  end

end
