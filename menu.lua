menu = {};
menu.items = {};

function menu.draw()
	for i,v in pairs(menu.items) do
		love.graphics.setColor(200,200,200);
		love.graphics.polygon("fill",
			{v.x, v.y, 
			 v.x+v.w, v.y,
			 v.x+v.w, v.y+v.h,
			 v.x, v.y+v.h }
		);
		love.graphics.setColor(0,0,0);
		love.graphics.print(v.text,v.x+5,v.y+(v.h/3));
	end
end

function menu.isClicked(x,y)
	for i,v in pairs(menu.items) do
		if x > v.x and x < v.x + v.w and y > v.y and y < v.y + v.h then
			v.func();
		end
	end
end

function menu.button(argX,argY,argW,argH,argText,argFunc)
	ID = #menu.items + 1;
	table.insert(menu.items,ID,{});
	menu.items[ID].x = argX;
	menu.items[ID].y = argY;
	menu.items[ID].w = argW;
	menu.items[ID].h = argH;
	menu.items[ID].text = argText;
	menu.items[ID].func = argFunc;
	
	
	return ID;
end