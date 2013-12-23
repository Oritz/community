# -*- encoding : utf-8 -*-
require "yaml"
require "net/http"
require 'rexml/document'
require "uri"
require "json"
require "cache/ext_platform_cache"

class ExtAchievement
	def self.get_steam_user_achievement(game_id, user_id, game_ext_id=nil, user_ext_id=nil, update_game=false)
		begin
			return false unless game_id
			return false unless user_id
			
			unless game_ext_id
				game_ext_ids = GameExtId.find(:first, :select => "ext_id", :conditions => ["game_id=:game_id", {:game_id => game_id}])
				return false unless game_ext_ids
				game_ext_id = game_ext_ids.ext_id
			end

			unless user_ext_id
				user_ext_ids = UserExtId.find(:first, :select => "ext_id", :conditions => ["account_id=:user_id AND ext_platform='steam'", {:user_id => user_id}])
				return false unless user_ext_ids
				user_ext_id = user_ext_ids.ext_id
			end
			
			config = get_steam_config
			achievements = nil
			if(user_ext_id.to_i.to_s == user_ext_id)
				# using profile id
				url = config["achievement_url"]["id"].gsub("##ACCOUNT##", user_ext_id)
				url = url.gsub("##GAME##", game_ext_id)
				achievements = get_steam_achievements_from_url(url, false)
			end
			unless achievements
				# maybe using curstomURL
				url = config["achievement_url"]["custom"].gsub("##ACCOUNT##", user_ext_id)
				url = url.gsub("##GAME##", game_ext_id)
				achievements = self.get_steam_achievements_from_url(url, false)
			end

			return false unless achievements

			sql_str = ""
			game_sql_str = ""
			connection = ActiveRecord::Base.connection
			ActiveRecord::Base.transaction do
				achievements.each_with_index do |achievement, index|
					name = CGI::escape(achievement[:name])
					score = 0
					earned_time = Time.at(achievement[:unlockTimestamp].to_i).strftime('%Y-%m-%dT%H:%M:%S')
					
					game_achievement = GameAchievement.find(:first, :select => "id", :conditions => ["title = :name AND game_id = :game_id", {:name => name, :game_id => game_id}]);
					unless game_achievement
						if update_game
							desc = CGI::escape(achievement[:description])
							icon = achievement[:iconClosed]
							icon_locked = achievement[:iconOpen]
							
							game_achievement = GameAchievement.create(
								:game_id => game_id,
								:achievement_name => name,
								:title => name,
								:max_value => score,
								:description => desc,
								:icon => icon,
								:icon_locked => icon_locked
							)
							next unless game_achievement
						else
							next
						end
					end
					player_achievement = PlayerAchievement.find(:first, :select => "id", :conditions => ["game_achievement_id=:a_id AND account_id=:user_id", {:a_id => game_achievement.id, :user_id => user_id}]);
					next if player_achievement
					sql_str << "(NULL, #{user_id}, #{game_achievement.id}, #{score}, '#{earned_time}'),"
					
					if sql_str != "" && ((index+1) % 10 == 0 || (index+1) == achievements.count)
						sql_str = "INSERT INTO player_achievements VALUES " + sql_str[0..-2]
						connection.execute(sql_str)
						sql_str = ""
					end
				end
			end
			true
		rescue
			false
		end
	end

	def self.get_xbl_user_profile(user_id, gamertag=nil)
		begin
			unless gamertag
				user_ext_id = UserExtId.find(:first, :conditions => ["ext_platform = 'xboxlive' AND account_id = :account_id", {:account_id => user_id}]);
				return nil unless user_ext_id
				gamertag = user_ext_id.ext_id
			end

			xbox_data = @platform_data[1]
			host = xbox_data["host"]
			port = xbox_data["port"]

			url = "http://#{host}:#{port}/profile?gamertag=#{parseXblGamertag(gamertag)}"
			http = Curl.get url
			data = JSON.parse http.body_str
			return nil unless data
			
			if data["code"].to_i == 0
				data["data"]
			else
				nil
			end
		rescue
			nil
		end
	end

	def self.get_xbl_user_achievement(game_id, user_id, game_ext_id=nil, user_ext_id=nil, update_game=false)
		begin
			return false unless game_id
			return false unless user_id
			
			unless game_ext_id
				game_ext_ids = GameExtId.find(:first, :select => "ext_id", :conditions => ["game_id=:game_id", {:game_id => game_id}])
				return false unless game_ext_ids
				game_ext_id = game_ext_ids.ext_id
			end

			unless user_ext_id
				user_ext_ids = UserExtId.find(:first, :select => "ext_id", :conditions => ["account_id=:user_id AND ext_platform='xboxlive'", {:user_id => user_id}])
				return false unless user_ext_ids
				user_ext_id = user_ext_ids.ext_id
			end
		
			xbox_config = get_xbox_config

			gamertag = user_ext_id
			titleId = game_ext_id
			#url = "http://#{xbox_config[:host]}:#{xbox_config[:port]}/achievement?gamertag=#{gamertag}&titleId=#{titleId}"
			#http = Curl.get url
			#data = JSON.parse http.body_str
			uri = URI("http://#{xbox_config[:host]}:#{xbox_config[:port]}/achievement?gamertag=#{parseXblGamertag(gamertag)}&titleId=#{titleId}")
			data = JSON.parse(Net::HTTP.get(uri))
			return false unless data

			if data["code"].to_i == 0
				# store them into db
				data = data["data"]
				achievements = data["achievements"]
				sql_str = ""
				game_sql_str = ""
				connection = ActiveRecord::Base.connection
				ActiveRecord::Base.transaction do
					achievements.each_with_index do |achievement, index|
						name = CGI::escape(achievement['info']['name'])
						score = achievement['player']['gamerscore']
						earned = achievement['player']['earnedOn']
						if(earned['year'] && earned['month'] && earned['day'])
							earned_time = Date.new(earned['year'].to_i, earned['month'].to_i, earned['day'].to_i).strftime('%Y-%m-%d')
						else
							earned_time = 0
						end
						
						game_achievement = GameAchievement.find(:first, :select => "id", :conditions => ["title = :name AND game_id = :game_id", {:name => achievement['info']['name'], :game_id => game_id}]);
						unless game_achievement
							if update_game
								desc = CGI::escape(achievement['info']['description'])
								icon = achievement['info']['unlocked_image']
								icon_locked = achievement['info']['locked_image']
								
								game_achievement = GameAchievement.create(
									:game_id => game_id,
									:achievement_name => name,
									:title => name,
									:max_value => score,
									:description => desc,
									:icon => icon,
									:icon_locked => icon_locked
								)
								next unless game_achievement
							else
								next
							end
						end
						player_achievement = PlayerAchievement.find(:first, :select => "id", :conditions => ["game_achievement_id=:a_id AND account_id=:user_id", {:a_id => game_achievement.id, :user_id => user_id}]);
						next if player_achievement
						sql_str << "(NULL, #{user_id}, #{game_achievement.id}, #{score}, '#{earned_time}'),"
						
						if sql_str != "" && ((index+1) % 10 == 0 || (index+1) == achievements.count)
							sql_str = "INSERT INTO player_achievements VALUES " + sql_str[0..-2]
							connection.execute(sql_str)
							sql_str = ""
						end
					end
				end
				true
			else
				false
			end
		rescue
			false
		end
	end

	def self.check_xbl_ext_id(gamertag)
		begin
			xbox_config = get_xbox_config
			url = "http://#{xbox_config[:host]}:#{xbox_config[:port]}/profile?gamertag=#{parseXblGamertag(gamertag)}"
			http = Curl.get url
			data = JSON.parse http.body_str
			return false unless data
			
			data["code"].to_i == 0
		rescue
			false
		end
	end

	private
	def self.get_game_ext_id(game_id, ext_platform)
		begin
			game_id = game_id.to_i
			return nil if game_id <= 0

			data = GameExtId.find(
				:first,
				:select => "game_id, ext_id",
				:conditions => ["ext_platform = :ext_platform AND game_id = :game_id", {:ext_platform => ext_platform, :game_id => game_id}]
			);
		rescue
			nil
		end
	end

	def self.get_xbox_config
		#platform_data = YAML.load_file("#{Rails.root}/config/app_data/ext_platforms.yml")
		xbox_data = ExtPlatformCache.get("xboxlive")
		host = xbox_data["host"]
		port = xbox_data["port"]

		return {:host => host, :port => port}
	end

	def self.get_steam_config
		config_data = ExtPlatformCache.get("steam")
		achievement_url = config_data['achievement_url']

		return {"achievement_url" => achievement_url}
	end

	def self.parseXblGamertag(gamertag)
		return "" unless gamertag
		return CGI::escape(gamertag.strip)
	end

	def self.fetch_url(uri_str, limit = 5)
		raise ArgumentError, 'HTTP redirect too deep' if limit == 0
		raise ArgumentError, 'Invalid uri' if uri_str == nil || uri_str == ""

		url = URI.parse(uri_str)
		response = Net::HTTP.get_response(url)
		case response
		when Net::HTTPSuccess
			then response
		when Net::HTTPRedirection
			then
				self.fetch_url(response['location'], limit - 1)
		when Net::HTTPServiceUnavailable
			then
				raise Net::HTTPServerException.new('503', 'server error')
		else
			raise Net::HTTPExcption.new('500', 'server error')
		end
	end

	def self.parse_steam_achievement(achievement)
		return nil unless achievement
		
		name = achievement.get_elements('name')[0]
		return nil unless
		desc = achievement.get_elements('description')[0]
		unlockTimestamp = achievement.get_elements('unlockTimestamp')[0]
		iconClosed = achievement.get_elements('iconClosed')[0]
		iconOpen = achievement.get_elements('iconOpen')[0]
		ret = {
			:name => name.get_text.value,
			:description => desc ? desc.get_text.value : "",
			:unlockTimestamp => unlockTimestamp ? unlockTimestamp.get_text.value : 0,
			:iconClosed => iconClosed ? iconClosed.get_text.value : "",
			:iconOpen => iconOpen ? iconOpen.get_text.value : ""
		}
	end

	def self.get_steam_achievements_from_url(url, is_game)
		unless url
			return nil
		end

		url = url.strip
		return nil if url == ""
		4.times {
			begin
				response = self.fetch_url(url)
				#parse data
				xml_data = response.body
				doc = REXML::Document.new(xml_data)

				playerstats = doc.get_elements('/playerstats')[0]
				return nil unless playerstats

				achievements = playerstats.get_elements('achievements')[0]
				return nil unless achievements

				ret = []
				if(is_game)
					achievements.each_element do |item|
						data = self.parse_steam_achievement(item)
						next unless data
						ret << data
					end
				else
					items = achievements.get_elements('achievement[@closed="1"]')
					items.each do |item|
						data = self.parse_steam_achievement(item)
						next unless data
						ret << data
					end
				end
				return ret
			rescue Net::HTTPServerException => e
				next
			rescue
				return nil
			end
		}
		return nil
	end
end
