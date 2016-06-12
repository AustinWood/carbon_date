require 'active_support/core_ext/integer/inflections'
require 'carbon_date/formatter'

module CarbonDate
  ##
  # The default formatter for CarbonDate::Date
  class StandardFormatter < Formatter

    ##
    # Suffix to use for Before Common Era dates (quite often BCE or BC)
    BCE_SUFFIX = 'BCE'

    MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

    private

    def year(date)
      y = date.year.abs.to_s
      return [y, BCE_SUFFIX].join(' ') if (date.year <= -1)
      y
    end

    def month(date)
      [MONTHS[date.month - 1], year(date)].join(', ')
    end

    def day(date)
      [date.day.ordinalize.to_s, month(date)].join(' ')
    end

    def hour(date)
      h = date.minute >= 30 ? date.hour + 1 : date.hour
      time = [pad(h.to_s), '00'].join(':')
      [time, day(date)].join(' ')
    end

    def minute(date)
      time = [pad(date.hour.to_s), pad(date.minute.to_s)].join(':')
      [time, day(date)].join(' ')
    end

    def second(date)
      time = [pad(date.hour.to_s), pad(date.minute.to_s), pad(date.second.to_s)].join(':')
      [time, day(date)].join(' ')
    end

    def decade(date)
      d = ((date.year.abs.to_i / 10) * 10).to_s + 's'
      return [d, BCE_SUFFIX].join(' ') if (date.year <= -1)
      d
    end

    def century(date)
      c = ((date.year.abs.to_i / 100) + 1).ordinalize + ' century'
      return [c, BCE_SUFFIX].join(' ') if (date.year <= -1)
      c
    end

    def millennium(date)
      m = ((date.year.abs.to_i / 1000) + 1).ordinalize + ' millennium'
      return [m, BCE_SUFFIX].join(' ') if (date.year <= -1)
      m
    end

    def ten_thousand_years(date)
      coarse_precision(date.year, 10e3.to_i)
    end

    def hundred_thousand_years(date)
      coarse_precision(date.year, 100e3.to_i)
    end

    def million_years(date)
      coarse_precision(date.year, 1e6.to_i)
    end

    def ten_million_years(date)
      coarse_precision(date.year, 10e6.to_i)
    end

    def hundred_million_years(date)
      coarse_precision(date.year, 100e6.to_i)
    end

    def billion_years(date)
      coarse_precision(date.year, 1e9.to_i)
    end

    def coarse_precision(date_year, interval)

      date_year = date_year.to_i
      interval = interval.to_i

      year_diff = date_year - ::Date.today.year
      return "Within the last #{number_with_delimiter(interval)} years" if (-(interval - 1)..0).include? year_diff
      return "Within the next #{number_with_delimiter(interval)} years" if (1..(interval - 1)).include? year_diff

      rounded = (year_diff.to_f / interval.to_f).round * interval
      return "in #{number_with_delimiter(rounded.abs)} years" if rounded > 0
      return "#{number_with_delimiter(rounded.abs)} years ago" if rounded < 0

      nil
    end

    def number_with_delimiter(n, delim = ',')
      n.to_i.to_s.reverse.chars.each_slice(3).map(&:join).join(delim).reverse
    end

    def pad(s)
      s.rjust(2, '0')
    end

  end
end