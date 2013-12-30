# -*- encoding : utf-8 -*-
module CommonAlgorithm

  def merge_list(old_arr, new_arr, &b)
    same_ids = old_arr & new_arr
    new_ids = new_arr - same_ids
    drop_ids = old_arr - same_ids
    yield(new_ids, drop_ids)
  end

  def median_for_sorted(a)
    s = a.size
    
    if s == 0
      median = 0
    elsif s == 1
       median = a[0]
    elsif s % 2 == 0
      median = (a[s/2 - 1] + a[s/2])/2
    else
      median = a[(s/2).to_i]
    end
    
  end
  
  def seconds_to_period(total_seconds)
    total_seconds = total_seconds.to_i
    
    days = total_seconds / 86400
    hours = (total_seconds / 3600) - (days * 24)
    minutes = (total_seconds / 60) - (hours * 60) - (days * 1440)
    seconds = total_seconds % 60
    
    period = ''
    period_concat = ''
    
    if days > 0
      period = period + period_concat + "#{days}" + " d"
      period_concat = ' '
    end
    
    if hours > 0 || period.length > 0
      period = period + period_concat + "#{hours}" + " h"
      period_concat = ' '
    end
    
    if minutes > 0 || period.length > 0
      period = period + period_concat + "#{minutes}" + " m"
      period_concat = ' '
    end
    
    period = period + period_concat + "#{seconds}" + " s"
  end
end
