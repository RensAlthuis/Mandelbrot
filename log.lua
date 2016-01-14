log = {};

log.entries = {};
log.start = 1;
log.max = 35;

function log.draw()
	love.graphics.setColor(0,0,0);
	love.graphics.line(800,0,800,H);
	love.graphics.setColor(50,50,50);
	love.graphics.polygon("fill",{802,0,W,0,W,H,802,H});
	love.graphics.setColor(255,255,255);
	love.graphics.print("DEBUG LOG - ENTRIES: " .. #log.entries .. " LOGSTART: " .. log.start, 815, 15);
	if #log.entries > 0 then
		for i = 0, math.min(#log.entries-1,log.max-1) do
			love.graphics.print(log.start+math.min(#log.entries-1,log.max-1)-i .. ". " .. log.entries[log.start+math.min(#log.entries-1,log.max-1)-i], 815, 30 + (i * 15));
		end
	end
end


function log.add(line)
	table.insert(log.entries,line);
	if log.start == #log.entries-log.max then
		log.start = log.start + 1;
	end
end