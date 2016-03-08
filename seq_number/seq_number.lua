local biz = 1

-- which time the timestamp bit record the time offset from
-- 2015-01-01
local _TIME_BEGIN = 1420041600
local _SEC_BIT_NUM = 31
local _BIZ_BIT_NUM = 3
local _ID_BIT_NUM = 18


-- local cjson = require "cjson"
local parser = require("redis.parser")

-- id generate
local res = ngx.location.capture("/incr", {
	args = "key=seq_num&val=2"
})
if res.status == 200 then
	local reply = parser.parse_reply(res.body)
	id = reply;
end
if (id) then
	id_bit_mod = math.ldexp(1, _ID_BIT_NUM)
    -- max odd
    if (id >= id_bit_mod-1 and (id % 2 == 1)) then
		local res = ngx.location.capture("/set", {
			args = "key=seq_num&val=-1"
		})
    end
    -- max even number
    if (id >= id_bit_mod-2 and (id %2 == 0)) then
		local res = ngx.location.capture("/set", {
			args = "key=seq_num&val=0"
		})
    end
else
    -- redis.log(redis.LOG_NOTICE, "seq_num id false")
end
id = id % id_bit_mod

-- sec generate
local res = ngx.location.capture("/time", {})
if res.status == 200 then
	local reply = parser.parse_reply(res.body)
	sec = reply[1]
end
if (sec) then
    sec = sec - _TIME_BEGIN
else
    -- redis.log(redis.LOG_NOTICE, "seq_num sec false")
	ngx.say('error')
end

local seq_number = math.ldexp(sec, _SEC_BIT_NUM) + math.ldexp(biz, _BIZ_BIT_NUM) + id
ngx.say(seq_number)
