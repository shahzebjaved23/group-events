require 'test_helper'

class GroupEventsControllerTest < ActionDispatch::IntegrationTest

	test 'index' do
		get group_events_url
		assert_response :success
		assert_equal 2, json_body['group_events'].length
	end

	test 'show' do
		get group_event_url(50)
		assert_equal 400, response.status
		assert_equal 'unable to find group event with id: 50', json_body['message']

		get group_event_url(1)
		assert_response :success
		assert_equal 'first event', json_body['group_event']['name']
	end

	test 'create' do
		post group_events_url, params: { group_event: { name: 'created event', description: 'some description', start_time: '2019-11-14T15:24:48Z', end_time: '2019-11-15T15:24:48Z' } }
		assert_response :success
		assert_equal 'created event', json_body['group_event']['name']
	end

	test 'update' do
		put group_event_url(1), params: { group_event: { name: 'updated event' } }
		assert_response :success
		assert_equal 'updated event', json_body['group_event']['name']
	end

	test 'destroy' do
		delete group_event_url(1)
		assert_response :success
		assert_equal 1, GroupEvent.count
		assert GroupEvent.unscoped.find_by_id(1).present?
		assert_equal 'group_event with id 1 destroyed successfully', json_body['message']
	end

	test 'publish' do
		put publish_group_event_url(1)
		assert_response :success
		assert GroupEvent.find(1).published?
		assert_equal 'published', json_body['group_event']['status']
	end

	test 'draft' do
		group_event = GroupEvent.find(2)
		assert group_event.published?

		put draft_group_event_url(2)
		assert_response :success
		assert group_event.reload.draft?
	end

end
