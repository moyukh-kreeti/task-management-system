module TasksHelper
  def interval_of_notifications
    @interval_of_notification = {
      1 => 1.days,
      2 => 7.days,
      3 => 1.months,
      4 => 3.months,
      5 => 6.months,
      6 => 1.years
    }
  end
end
