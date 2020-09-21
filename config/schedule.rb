# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
set :output, "log/cron.log"
#
#
every 2.hours do
  rake 'products_stock_update:update_inventory'
end

every :day, at: '12pm' do
  rake 'products_stock_update:update_stock'
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
