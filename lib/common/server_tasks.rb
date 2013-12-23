# -*- encoding : utf-8 -*-

require 'json'
require 'date'
#require 'curb'
require 'active_record'
require 'common/ext_achievement'



#
# 注意:
# 此文件定义定时任务，注意须保证多次运行无副作用
#


class ServerTasks
	
	def self.t1(scheduled_time)
		puts "----- ServerTasks.t1, scheduled_time: #{scheduled_time}, now: #{Time.now}"
	end


	def self.t2(scheduled_time)
		puts "----- ServerTasks.t2, scheduled_time: #{scheduled_time}, now: #{Time.now}"
	end


	# 统计在线人数
	def self.stat_online_user(scheduled_time)
		puts "----- ServerTasks.stat_online_user, scheduled_time: #{scheduled_time}, now: #{Time.now}"
				
		history = OnlineHistory.find(
			:first,
			:conditions=>["created_at=?", scheduled_time]
		)
		
		return if history
		
		cnt = Session.count(
			:all,
			:conditions=>["updated_at>=?", scheduled_time - 15 * 60]	# 假定15分钟为活跃期
		)

		history = OnlineHistory.new
		
		history.online_count = cnt
		history.created_at = scheduled_time
		history.save!

		puts "Update online count finished at " + Time.now.to_s
	end
	
	
	# 地区销售数据日统计，注意：昨日数据
	def self.stat_region_sales(scheduled_time)
		puts "----- ServerTasks.stat_online_user, scheduled_time: #{scheduled_time}, now: #{Time.now}"
		
		date = Time.at(scheduled_time).at_beginning_of_day - 1.days # 昨日数据

		RegionSale.delete_all(["date=?", date])

		# regions = Region.find(:all)
		
		online_sales = OrderItem.find(
			:all,
			:joins => "INNER JOIN orders ON orders.id=order_items.order_id",
			:select => "game_id, (SELECT region_id FROM region_ip_sections WHERE start_ip<=INET_ATON(user_ip) AND end_ip>=INET_ATON(user_ip) LIMIT 1) AS region_id, COUNT(game_id) AS units, SUM(real_price) AS total_sum",
			:conditions => ["order_status=? AND payment_time>=? AND payment_time<?", Order::STATUS_COMPLETED, date.to_i, (date + 1.days).to_i],
			:group => "game_id, region_id"
		)
		
		# p online_sales
		
		online_sales.each do |s|
			region_sale = RegionSale.new(
				:date => date,
				:game_id => s.game_id,
				:region_id => s.region_id,
				:online_units => s.units,
				:online_sum => s.total_sum
			)
			
			region_sale.save!
		end
		
		puts "Update online count finished at " + Time.now.to_s
	end
	
	
	# 同步外部成就
	def self.get_ext_achievements(scheduled_time)
		puts "----- ServerTasks.get_ext_achievements, scheduled_time: #{scheduled_time}, now: #{Time.now}"

		game_ext_ids = GameExtId.find(:all, :select => "game_id, ext_platform, ext_id")
		user_ext_ids = UserExtId.find(:all, :select => "account_id, ext_platform, ext_id")
		puts "games count : #{game_ext_ids.length}"
		game_ext_ids.each do |item|
			game_id = item.game_id
			ext_platform = item.ext_platform
			ext_id = item.ext_id

			user_ext_ids.each do |user|
				next if user.ext_platform != ext_platform
				next if user.ext_id == ""
				if ext_platform == "xboxlive"
					next if user.ext_id.index('@')
					ret = ExtAchievement.get_xbl_user_achievement(game_id, user.account_id, ext_id, user.ext_id)
					puts "scrap failed for #{user.account_id}, ext_id : #{user.ext_id}, game_id : #{game_id}" unless ret
				elsif ext_platform == "steam"
					ret = ExtAchievement.get_steam_user_achievement(game_id, user.account_id, ext_id, user.ext_id)
					puts "scrap #{ext_platform} failed for #{user.account_id}, ext_id : #{user.ext_id}, game_id : #{game_id}" unless ret
				else
					puts "other platforms"
				end
			end
		end
	end
end







