基于ngx\_lua + redis的发号器

	避免PHP直连redis, phpredis低版本客户端整形溢出问题

示例:

	curl "http://localhost:8080/seq_number/?biz=1&ins=1"

	参数:
		biz business code, seq_number/seq_number.lua可以指定这一字段长度
		ins instance id, seq_number/seq_number.lua可以指定这一字段长度

依赖:

	nginx module

		1. ngx_devel_kit
		2. set-misc-nginx-module
		3. lua-nginx-module
		4. redis2-nginx-module
		5. echo-nginx-module
