class GroupEventsController < ApplicationController

	protect_from_forgery with: :null_session
	before_action :find_group_event, only: [:update, :show, :destroy, :publish, :draft]
	before_action :set_group_event, only: [:create]

	def index
		@group_events = GroupEvent.all
		render json: { group_events: @group_events }
	end 

	def show
		render json: { group_event: @group_event }
	end

	def create
		if @group_event.save
			render json: { group_event: @group_event }
		else
			render json: { message: @group_event.errors.messages }, status: 403
		end
	end

	def update
		if @group_event.update(group_event_params)
			render json: { group_event: @group_event }
		else
			render json: { message: @group_event.errors.messages }, status: 403
		end
	end

	def destroy
		@group_event.destroy
		render json: { message: "group_event with id #{params[:id]} destroyed successfully" }
	end

	def draft
		if @group_event.draft_event
			render json: { group_event: @group_event }
		else
			render json: { message: @group_event.errors.messages }, status: 403
		end
	end

	def publish
		if @group_event.publish_event
			render json: { group_event: @group_event }
		else
			render json: { message: @group_event.errors.messages }, status: 403
		end
	end

	private

	def find_group_event
		@group_event = GroupEvent.find_by_id(params[:id])

		if @group_event.nil?
			render json: { message: "unable to find group event with id: #{params[:id]}" }, status: 400 and return
		end
	end

	def set_group_event
		@group_event = GroupEvent.new(group_event_params)
	end

	def group_event_params
		params.require(:group_event).permit([:start_time, :end_time, :name, :description, :location])
	end

end
