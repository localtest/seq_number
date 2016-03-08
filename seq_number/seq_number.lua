-- biz 01 - 15
--local biz = tonumber(KEYS[1])
-- random 01 - 15
--local random = tonumber(KEYS[2])

local biz = 1
local random = 2

-- which time the timestamp bit record the time offset from
-- 2015-01-01
local _TIME_BEGIN = 1420041600


local cjson = require "cjson"
local parser = require("redis.parser")

-- id 16bit
local res = ngx.location.capture("/incr", {
	args = "key=seq_num&val=2"
})
if res.status == 200 then
	local reply = parser.parse_reply(res.body)
	id = reply;
end
if (id) then
    -- max odd
    if (id >= 65535 and (id % 2 == 1)) then
		local res = ngx.location.capture("/set", {
			args = "key=seq_num&val=-1"
		})
    end
    -- max even number
    if (id >= 65534 and (id %2 == 0)) then
		local res = ngx.location.capture("/set", {
			args = "key=seq_num&val=0"
		})
    end
else
    -- redis.log(redis.LOG_NOTICE, "seq_num id false")
    -- return false
end
id = id % 65536


-- sec 10 bit
local res = ngx.location.capture("/time", {})
if res.status == 200 then
	local reply = parser.parse_reply(res.body)
	sec = reply[1]
end
if (sec) then
    sec = sec - _TIME_BEGIN
else
    -- redis.log(redis.LOG_NOTICE, "seq_num sec false")
    -- return false
	ngx.say('error')
end


-- sec*2^24 + biz*2^20 + random*2^16 + id
-- local seq_number = 'sec: '..sec..', biz: '..biz..', random: '..random..', id: '..id
local seq_number = sec*16777216 + biz*1048576 + random*65536 + id
ngx.say(seq_number)
