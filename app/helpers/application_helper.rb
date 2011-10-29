module ApplicationHelper
  def get_weekdays
    @weekdays = Array.new

    if Time.zone.now.wday == 0
      @start_from = 1
    elsif Time.zone.now.wday == 1
      @start_from = 0
    elsif Time.zone.now.wday == 2
      @start_from = -1
    elsif Time.zone.now.wday == 3
      @start_from = -2
    elsif Time.zone.now.wday == 4
      @start_from = -3
    elsif Time.zone.now.wday == 5
      @start_from = -4
    elsif Time.zone.now.wday == 6
      @start_from = 2
    end

    @i = 0
    while @i < 5
      @weekdays << Time.now + @start_from.days
      @start_from = @start_from + 1
      @i = @i + 1
    end
    return @weekdays

  end

  def get_first_day(date)
    if Date.parse(date).wday == 0
      return Date.parse(date) - 1.day
    elsif Date.parse(date).wday == 1
      return Date.parse(date) - 2.days
    elsif Date.parse(date).wday == 2
      return Date.parse(date) - 3.days
    elsif Date.parse(date).wday == 3
      return Date.parse(date) - 4.days
    elsif Date.parse(date).wday == 4
      return Date.parse(date) - 5.days
    elsif Date.parse(date).wday == 5
      return Date.parse(date) - 6.days
    elsif Date.parse(date).wday == 6
      return Date.parse(date) - 7.days
    end
  end

  def get_next_weekday

    if Time.now.wday == 0
      @start_from = 1
    elsif Time.now.wday == 1
      @start_from = 0
    elsif Time.now.wday == 2
      @start_from = -1
    elsif Time.now.wday == 3
      @start_from = -2
    elsif Time.now.wday == 4
      @start_from = -3
    elsif Time.now.wday == 5
      @start_from = -4
    elsif Time.now.wday == 6
      @start_from = 2
    end

    return @start_from

  end

  def scheduled?(schedule, day)
    if schedule
      return schedule.send("#{day}_scheduled")
    end
  end

  def delivered?(schedule, day)
    if schedule
      return schedule.send("#{day}_delivered")
    end
  end

  def before_schedule_delivery_cutoff(date)
    if Time.now < Time.local(date.strftime("%Y"), date.strftime("%m"), date.strftime("%d"), 8)
      return true
    else
      return false
    end
  end

  def next_delivery(recipient)
    @next_five_days = get_weekdays
    #@temp_schedule = RecipientTemporarySchedule.find_last_by_location_recipient_id(recipient)
    @temp_schedule = UserTemporarySchedule.find_last_by_user_id(recipient)
    if scheduled?(@temp_schedule, "monday") and not delivered?(@temp_schedule, "monday") and before_schedule_delivery_cutoff(@next_five_days[0])
      return 0
    elsif scheduled?(@temp_schedule, "tuesday") and not delivered?(@temp_schedule, "tuesday") and before_schedule_delivery_cutoff(@next_five_days[1])
      return 1
    elsif scheduled?(@temp_schedule, "wednesday") and not delivered?(@temp_schedule, "wednesday") and before_schedule_delivery_cutoff(@next_five_days[2])
      return 2
    elsif scheduled?(@temp_schedule, "thursday") and not delivered?(@temp_schedule, "thursday") and before_schedule_delivery_cutoff(@next_five_days[3])
      return 3
    elsif scheduled?(@temp_schedule, "friday") and not delivered?(@temp_schedule, "friday") and before_schedule_delivery_cutoff(@next_five_days[4])
      return 4
    else
      return 5
    end
  end

  def get_service_plan(plan_number)
    if plan_number == 1
      return "Basic"
    elsif plan_number == 2
      return "Prime"
    elsif plan_number == 3
      return "Premium"
    end
  end

  def get_delivery_status(date, recipient_id)
    @appended_string = "#{date.strftime("%A").downcase}_delivered"
    @this_weeks_schedule = RecipientTemporarySchedule.find_by_location_recipient_id(recipient_id)
    @status = @this_weeks_schedule.send(@appended_string)
    return @status
  end

  def set_initial_temp_schedule(start_from, recipient_temp_schedule, recipient_reg_schedule)
    if start_from == 0
      recipient_temp_schedule.update_attributes( :monday_scheduled => recipient_reg_schedule.monday_scheduled, :tuesday_scheduled => recipient_reg_schedule.tuesday_scheduled,
                                                 :wednesday_scheduled => recipient_reg_schedule.wednesday_scheduled, :thursday_scheduled => recipient_reg_schedule.thursday_scheduled,
                                                 :friday_scheduled => recipient_reg_schedule.friday_scheduled )
    elsif start_from == 1
      recipient_temp_schedule.update_attributes( :monday_scheduled => false, :tuesday_scheduled => recipient_reg_schedule.tuesday_scheduled,
                                                 :wednesday_scheduled => recipient_reg_schedule.wednesday_scheduled, :thursday_scheduled => recipient_reg_schedule.thursday_scheduled,
                                                 :friday_scheduled => recipient_reg_schedule.friday_scheduled )
    elsif start_from == 2
      recipient_temp_schedule.update_attributes( :monday_scheduled => false, :tuesday_scheduled => false, :wednesday_scheduled => recipient_reg_schedule.wednesday_scheduled, :thursday_scheduled => recipient_reg_schedule.thursday_scheduled,
                                                 :friday_scheduled => recipient_reg_schedule.friday_scheduled )
    elsif start_from == 3
      recipient_temp_schedule.update_attributes( :monday_scheduled => false, :tuesday_scheduled => false, :wednesday_scheduled => false,
                                                 :thursday_scheduled => recipient_reg_schedule.thursday_scheduled, :friday_scheduled => recipient_reg_schedule.friday_scheduled )
    elsif start_from == 4
      recipient_temp_schedule.update_attributes( :monday_scheduled => false, :tuesday_scheduled => false, :wednesday_scheduled => false,
                                                 :thursday_scheduled => false, :friday_scheduled => recipient_reg_schedule.friday_scheduled )
    elsif start_from == 5
      recipient_temp_schedule.update_attributes( :monday_scheduled => false, :tuesday_scheduled => false, :wednesday_scheduled => false,
                                                 :thursday_scheduled => false, :friday_scheduled => false )
    end
  end

  def get_edit_explanation(type)
    if type == "name"
      return "A recipient's display name serves two purposes. First, it is how the recipient is identified by the account owner. Second, our drivers use it to identify the person who we're delivering to. Choosing a name that is recognizable by the recipient helps us get your meals to the right people.<br><br>A phone number is used solely to contact the recipient in the case that a problem arises in the delivery process.<br><br>All information is stored securely and not shared with anybody else."
    elsif type == "schedule"
      return "A recipient's regular schedule is used as the default each week when the next 5 day delivery schedule is set. <p>For example, if you know that you are seldom in the office on Fridays, you might consider not scheduling Friday deliveries on your regular schedule.</p> Then, if you are around on a particular Friday and want us to bring you lunch, simply schedule a delivery for that Friday on your dashboard. That way we can bring you a lunch on that particular Friday without requiring you to manage changes to your schedule every week."
    elsif type == "location"
      return "A recipient's pickup location is, quite simply, where each meal will be delivered."
    end
  end

  def get_next_five_day_index(selected_date)
    if selected_date.wday == 0 or selected_date.wday == 1 or selected_date.wday == 6
      @next_five_days_index = 0
    elsif selected_date.wday == 2
      @next_five_days_index = 1
    elsif selected_date.wday == 3
      @next_five_days_index = 2
    elsif selected_date.wday == 4
      @next_five_days_index = 3
    elsif selected_date.wday == 5
      @next_five_days_index = 4
    end
    return @next_five_days_index
  end
end
