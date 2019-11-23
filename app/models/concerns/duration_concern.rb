module DurationConcern

	def formatted_duration
		return if duration.nil?
		return if !whole_number_days?
		num_days = duration.to_i / ( 24 * 60 * 60 )
    "#{num_days} day#{ num_days == 1 ? '' : 's'}" 
	end

	def whole_number_days?
		days = duration / (24 * 60 * 60)
		days - days.to_i == 0
	end

	def should_have_duration?
		start_time.present? && end_time.present?
	end

end