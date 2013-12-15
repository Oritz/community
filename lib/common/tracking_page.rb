# -*- encoding : utf-8 -*-
require "cache/sys_params_cache"

module TrackingPage
	@@ignore_date = Time.parse(SysParamsCache.get("IGNORE_PUBLISHER_DATA_BRFORE"))


	#统计男女比例
	def get_count_by_gender(query_conditions)

		boy_count = girl_count = 0
		count = Account.find(
			:all,
			:select => "gender, count(accounts.id) AS count",
			:joins => "LEFT JOIN sg_users ON accounts.id = sg_users.account_id",
			:group => "gender",
			:conditions => query_conditions
		)

		if count

			count.each do |c|
				if c.gender.to_i == SgUser::GENDER_BOY
					boy_count = c.count.to_i
				elsif c.gender.to_i == SgUser::GENDER_GIRL
					girl_count = c.count.to_i
				end

				if boy_count == 0 && girl_count == 0
					boy_count = girl_count = 1
				end
			end
		end

		gender_data = []
		gender_data.push({:label => I18n.t("page.admin.genders")[SgUser::GENDER_BOY], :data => boy_count})
		gender_data.push({:label => I18n.t("page.admin.genders")[SgUser::GENDER_GIRL], :data => girl_count})

		json_data = gender_data.to_json
	end


	#统计支付方式比例
	def paymethod_scale(query_conditions= nil )

		orders = Order.find(
			:all,
			:select => "payment_method, COUNT(DISTINCT orders.id) AS count",
			:group => "payment_method",
			:conditions => query_conditions
		)

		order_data = []

		orders.each do |uo|
			order_data.push({ :label =>uo.payment_method, :data => uo.count.to_i})
		end

		order_data_json = order_data.to_json
	end



	#统计讨费玩家比例
	def paid_user_scale_at(star_time=@@ignore_date, end_time=Time.now)

		all_account = Account.count(
			:conditions =>["created_at >= ? AND created_at < ?", star_time, end_time]
		)

		paid_count = UserOrder.count(
			"DISTINCT(account_id)",
			:joins => "INNER JOIN accounts ON user_orders.account_id=accounts.id INNER JOIN orders ON orders.id=user_orders.order_id",
			:conditions => ["order_status=? AND created_at>=? AND created_at<?", Order::STATUS_COMPLETED, star_time, end_time]
		)

		unless all_account == 0
			no_pay_count = all_account - paid_count
		else
			no_pay_count = 0
			paid_count = 0
		end

		data = []
		data.push({:label =>I18n.t("page.admin.if_paid")[Account::PAID_USER], :data =>paid_count})
		data.push({:label =>I18n.t("page.admin.if_paid")[Account::PAID_USER], :data =>no_pay_count})

		data_json = data.to_json

	end



	def get_gender_count_for_bar(query_group, query_conditions)
		count = Account.find(
			:all,
			:select => "COUNT(accounts.id) AS count, created_at, gender",
			:joins => "INNER JOIN sg_users ON accounts.id = sg_users.account_id",
			:group => query_group,
			:conditions => query_conditions
		)

		data = []
		count.each do |c|
			data.push([c.created_at.to_i * 1000, c.count.to_i])
		end

		#查的到数据，性别取决于查到数据的性别，如果没有数据默认无数据的性别为女。
		unless count.empty?
			gender_data = {:label =>I18n.t("page.admin.genders")[count[0].gender.to_i], :data =>data }
		else
			gender_data = {:label =>I18n.t("page.admin.genders")[SgUser::GENDER_GIRL], :data =>data }
		end
	end



	def get_paymethod_count_for_bar(query_group, query_conditions)
		orders = Order.find(
			:all,
			:select => "payment_method, COUNT(DISTINCT(orders.id)) AS count, payment_time, order_status",
			:group => query_group,
			:conditions => query_conditions
		)

		data = []
		unless orders.empty?
			orders.each do |uo|
				data.push([uo.payment_time * 1000, uo.count.to_i])
			end

			paymethod_data = {:label =>orders[0].payment_method, :data =>data }
		else
			return nil
		end

		return paymethod_data
	end



	def get_paiduser_for_bar(query_group)
		paid_group = {}
		paid_group["day"] = "DATE_FORMAT(FROM_UNIXTIME(payment_time), '%y-%m-%d')"
		paid_group["month"] = "DATE_FORMAT(FROM_UNIXTIME(payment_time), '%y-%m')"
		paid_group["week"] = "DATE_FORMAT(FROM_UNIXTIME(payment_time), '%y-%u')"

		no_pay_group = {}
		no_pay_group["day"] = "DATE_FORMAT(created_at, '%y-%m-%d')"
		no_pay_group["month"] = "DATE_FORMAT(created_at, '%y-%m')"
		no_pay_group["week"] = "DATE_FORMAT(created_at, '%y-%u')"

		paid_user = OrderItem.find(
			:all,
			:select => "COUNT(DISTINCT(account_id)) AS count, payment_time",
			:joins => "INNER JOIN user_orders ON order_items.order_id=user_orders.order_id INNER JOIN orders ON orders.id=order_items.order_id",
			:conditions => ["order_status=?", Order::STATUS_COMPLETED],
			:group => paid_group[query_group]
		)

		no_paid_user = Account.find(
			:all,
			:select => "COUNT(id) AS count, created_at",
			:group => no_pay_group[query_group],
			:conditions => ["id NOT IN (SELECT account_id FROM user_orders INNER JOIN orders ON orders.id=user_orders.order_id WHERE order_status='#{Order::STATUS_COMPLETED}')"]
		)

		paid_data = []
		paid_user.each do |pu|
			paid_data.push([pu.payment_time * 1000, pu.count])
		end

		no_pay_data = []
		no_paid_user.each do |nu|
			no_pay_data.push([nu.created_at.to_i * 1000, nu.count.to_i]) if nu.created_at
		end

		paid_user_data = {:label =>I18n.t("page.admin.if_paid")[Account::PAID_USER], :data => paid_data}
		no_pay_user_data = {:label =>I18n.t("page.admin.if_paid")[Account::PAID_USER], :data => no_pay_data}

		all_data = []
		all_data.push(paid_user_data)
		all_data.push(no_pay_user_data)

		all_data = all_data.to_json
	end
end
