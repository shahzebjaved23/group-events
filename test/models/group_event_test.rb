require 'test_helper'

class GroupEventTest < ActiveSupport::TestCase
  test 'group event should have duration in whole number' do
  	group_event = GroupEvent.new(name: 'some name', description: 'some description', start_time: '2019-12-05T15:24:48Z', end_time: '2019-12-06T15:24:48', location: 'some location')
  	assert group_event.valid?
  	assert_equal '1 day', group_event.formatted_duration

  	group_event.start_time = group_event.start_time + 10.seconds
  	assert_not group_event.valid?
  	assert_equal ["the event should run for whole number of days"], group_event.errors.messages[:duration]
  	assert_nil group_event.formatted_duration 
  end

  test 'group event should have end_time less than start_time' do
  	group_event = GroupEvent.new(name: 'some name', description: 'some description', start_time: '2019-12-05T15:24:48Z', end_time: '2018-12-06T15:24:48', location: 'some location')
  	
  	assert_not group_event.valid?
  	assert ["cannot be before start time"], group_event.errors.messages[:end_time]
  end

  test 'group event should be soft deleted' do
  	group_event = GroupEvent.find(1)
  	group_event.destroy

  	assert_equal 1, GroupEvent.count 
  	assert GroupEvent.unscoped.find(1).present?
  end 

  test 'all required attributes must be preset to publish' do
  	group_event = GroupEvent.new(name: 'some name', description: 'some description', start_time: '2019-12-05T15:24:48Z')
  	group_event.publish_event

  	assert_not group_event.valid?
  	assert_equal ["End time missing required fields to publish", "Location missing required fields to publish"], group_event.errors.full_messages
  end
end
