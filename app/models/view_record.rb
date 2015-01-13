class ViewRecord < ActiveRecord::Base
  attr_accessible :id, :user_id, :wave_id

  validates_uniqueness_of :user_id, scope: [:wave_id]

  def self.create_view_records(user_id, wave_ids)
    attr_list = []

    wave_ids.each do |id|
      attr_list << { user_id: user_id, wave_id: id }
    end

    ViewRecord.create(attr_list)
  end
end
