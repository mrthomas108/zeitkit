class ErrorCalculation
  def perform
    @total_seconds = 0

    # Get all worklogs from EasyMarketing
    logs = Worklog.where('client_id = ? AND created_at >= ?', 391, DateTime.now.beginning_of_year)
    logs = logs.where(hourly_rate_cents: '6000')
    logs = logs.where(user_id: client.client_shares.map(&:user_id))
    # Now we have all logs that contain the hourly_rate of 60€ and were NOT
    # made by Hendrik

    logs.map do |l|
      @total_seconds += l.duration
    end

    puts
    puts "Kosten à 60€: "
    cost_sixty = seconds_to_hours(@total_seconds) * 60.00
    puts cost_sixty
    puts

    puts "Kosten à 50€: "
    cost_fifty = seconds_to_hours(@total_seconds) * 55.00
    puts cost_fifty
    puts

    puts "Differenz: "
    puts cost_sixty - cost_fifty
  end

  def client
    @client ||= Client.find(391)
  end

  def seconds_to_hours(seconds)
    return ((seconds.to_f / 60) / 60)
  end
end
