local cjson = require "cjson"
local server_section = arg[1]
local proto = arg[2]
local local_port = arg[3] or "0"
local socks_port = arg[4] or "0"
local ssrindext = io.popen("dbus get ssconf_basic_json_" .. server_section)
local outbound_security = "none"
local servertmp = ssrindext:read("*all")
local server = cjson.decode(servertmp)
if (server.tls == '2')
then
	outbound_security = "xtls"
elseif (server.tls == '1')
then
	outbound_security = "tls"
end

local vless = {
log = {
	-- error = "/tmp/ssrplus.log",
loglevel = "warning"
},
-- 传入连接
inbound = (local_port ~= "0") and {
	port = local_port,
	protocol = "dokodemo-door",
	settings = {
		network = proto,
		followRedirect = true
	},
	sniffing = {
		enabled = true,
		destOverride = { "http", "tls" }
	}
} or nil,
-- 开启 socks 代理
inboundDetour = (proto == "tcp" and socks_port ~= "0") and {
	{
	protocol = "socks",
	port = socks_port,
		settings = {
			auth = "noauth",
			udp = true
		}
	}
} or nil,
-- 传出连接
outbound = {
	protocol = "vless",
	settings = {
		vnext = {
			{
				address = server.server,
				port = tonumber(server.server_port),
				users = {
					{
							id = server.vmess_id,
							flow = ((server.flow == '1') and "xtls-rprx-direct") or ((server.flow == '2') and "xtls-rprx-splice") or nil,
						encryption = server.security,
						level = tonumber(server.alter_id)
					}
				}
			}
		}
	},
	-- 底层传输配置
	streamSettings = {
		network = server.transport,
		security = outbound_security,
		tlsSettings = (outbound_security == "tls") and {serverName=server.tls_host,} or nil,
		xtlsSettings = (outbound_security == "xtls") and {serverName=server.tls_host,} or nil,
		tcpSettings = (server.transport == "tcp"  and server.tls ~= '2' ) and {
			header = {
				type = server.tcp_guise,
				request = {
					path = server.http_path or {"/"},
					headers = {
						Host = server.http_host or {}
					}
				} or {}
			}
		} or nil,
		kcpSettings = (server.transport == "kcp") and {
			mtu = tonumber(server.mtu),
			tti = tonumber(server.tti),
			uplinkCapacity = tonumber(server.uplink_capacity),
			downlinkCapacity = tonumber(server.downlink_capacity),
			congestion = (server.congestion == "1") and true or false,
			readBufferSize = tonumber(server.read_buffer_size),
			writeBufferSize = tonumber(server.write_buffer_size),
			header = {
				type = server.kcp_guise
			}
		} or nil,
		wsSettings = (server.transport == "ws") and (server.ws_path ~= nil or server.ws_host ~= nil) and {
			path = server.ws_path,
			headers = (server.ws_host ~= nil) and {
				Host = server.ws_host
			} or nil,
		} or nil,
		grpcSettings = (server.transport == "grpc") and (server.ws_path ~= nil) and {
			serviceName = server.ws_path,
			multiMode=false
		} or nil,
		httpSettings = (server.transport == "h2") and {
			path = server.h2_path,
			host = server.h2_host,
		} or nil,
		quicSettings = (server.transport == "quic") and {
			security = server.quic_security,
			key = server.quic_key,
			header = {
				type = server.quic_guise
			}
		} or nil
	},
	mux = {
		enabled = (server.mux == "1") and true or false,
		concurrency = tonumber(server.concurrency)
	}
},
-- 额外传出连接
outboundDetour = {
		{
			protocol = "freedom",
			tag = "direct",
			settings = { keep = "" }
		}
	}
}
print(cjson.encode(vless))