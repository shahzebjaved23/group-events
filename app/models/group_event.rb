class GroupEvent < ApplicationRecord

  include DurationConcern

  STATUSES = ['draft', 'published'] 
  REQUIRED_PUBLISH_ATTRIBUTES = ['start_time', 'end_time', 'name', 'description', 'location', 'status']

  validate :valid_duration_in_whole_number_of_days
  validate :valid_start_time_and_end_time
  validates :status, inclusion: { in: STATUSES }, allow_blank: false  # default: draft
  validates_presence_of *REQUIRED_PUBLISH_ATTRIBUTES.map(&:to_s), message: 'missing required fields to publish', if: :published?

  default_scope { where(deleted_at: nil) }


  def as_json(options = {})
    attributes.merge('duration' => formatted_duration)
  end

  def destroy
    update_attributes(deleted_at: Time.now.utc)
  end

  def draft_event
    update_attributes(status: :draft)
  end

  def publish_event
    update_attributes(status: :published)
  end

  def draft?
    status == 'draft'
  end

  def published?
    status == 'published'
  end

  private

  def duration
    end_time - start_time if should_have_duration?
  end

  def valid_duration_in_whole_number_of_days
    if should_have_duration? && !whole_number_days?
      errors.add(:duration, "the event should run for whole number of days")
    end
  end

  def valid_start_time_and_end_time
    if should_have_duration? && end_time <= start_time
      errors.add(:end_time, "cannot be before start time")
    end
  end

end
