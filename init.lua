outpin=4;
gpio.write(outpin,gpio.LOW);
state="Off";
debug = false;

srv=net.createServer(net.TCP, 30)

srv:listen(80,function(conn)
	conn:on("receive", function(conn,payload)
		if debug then print(payload) end;
	
		if string.find(payload, "GET /on ") then
			state = "On";
			gpio.write(outpin,gpio.HIGH);
		elseif string.find(payload, "GET /off ") then
			state = "Off";
			gpio.write(outpin,gpio.LOW);
		end;
		if debug then print(state) end;
		conn:send('HTTP/1.1 200 OK\n\n')
		conn:send('<!DOCTYPE HTML>\n<html>\n')
		conn:send('<head><meta content="text/html; charset=utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0"/>')
		conn:send('<title>Bedside Lamp-o</title>\n')
		conn:send('<style type="text/css">\n')
		conn:send('body { padding:0; margin:0; }\n')
		conn:send('a { border:none; display:table-cell; font-size:36px; width:100vw; height: 100vh; margin:0; text-align:center; font-family:helvetica-neue, helvetica, arial, sans-serif; text-decoration:none; vertical-align: middle; }\n')
		conn:send('.offButton { background-color: #990000; color: #ff9999; }\n')
		conn:send('.onButton { background-color: #009900; color: #99ff99;}\n')
		conn:send('</style>\n')
		conn:send('</head>\n')
		if state=="On" then
			conn:send('<a href="/off" class="offButton">Off</a>\n');
		else
			conn:send('<a href="/on" class="onButton">On</a>\n');
		end;
		conn:send('</body></html>\n')
		conn:close();
		collectgarbage();
	end)
end)