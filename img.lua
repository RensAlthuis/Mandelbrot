img = {};


img.size = 800;
img.frequency = 2;
seed = 0;
grid = {};
points = {};
pixels = {};
img.curTable = "empty";
img.mandel = {};
img.mandel.cx = 0;
img.mandel.cy = 0;
img.mandel.scale = 0.02;
img.mandel.limit = 4;
img.mandel.width = 800;
img.mandel.height = 800;
img.mandel.maxIter = 200;
img.mandel.histogram = {};
img.mandel.pallete = {};
img.mandel.nPallete = 0;
img.mandel.iPallete = 0;

function img.draw() 
	for y, vy in pairs(pixels) do
		for x, vx in pairs(vy) do
			love.graphics.setColor(vx);
			love.graphics.points(x,y);
		end
	end
end

function img.new(s, freq)
	grid = {};
	local pointTable = {};
    
	if s then
		seed = s;
		math.randomseed(seed);
	end
	
	
	----------------------
	-- points 40x40
	-- pixels 500x500
	-- scale floor(500/40)
	----------------------
	
	for x = 0, freq do
		grid[x] = {};
	end
	
	for x = 0, freq do
		for y = 0, freq do
			grid[x][y] = (math.random(0,1000000)/1000000);
		end
	end
	
	----------------------
	for x = 0, img.size do
		pointTable[x] = {};
	end
	
	local base = img.size/freq;
	
	for x = 0, img.size -1 do
		local basePointX,fracX = math.modf(x/base);

		for y = 0, img.size -1 do
			local basePointY,fracY = math.modf(y/base);
			
			local p1 = grid[basePointX][basePointY];
			local p2 = grid[basePointX + 1][basePointY];
			local p3 = grid[basePointX][basePointY + 1];
			local p4 = grid[basePointX + 1][basePointY + 1];	
			local temp1 = img.cosine(p1,p2,fracX);
			local temp2 = img.cosine(p3,p4,fracX);
			
			pointTable[x][y] = img.cosine(temp1,temp2,fracY);
		end
	end

	return pointTable;
end

function img.setImg(pointTable)	
    img.curTable = "color";
	for x = 0, img.size do
		pixels[x] = {};
	end
	
	for y = 0, img.size - 1 do  
		for x = 0, img.size -1 do
            if pointTable[x][y] ~= nil then
                pixels[x][y] = img.hslToRgb(math.floor(pointTable[x][y]*360),1,0.5); 
                --pixels[x][y] = img.hslToRgb(240,pointTable[x][y],0.5); 
                
            else
                pixels[x][y] = {0,0,0};
            end
			--local c = pointTable[x][y]*255;
			--pixels[x][y] = {c,c,c}
		end
	end
end

function img.hslToRgb( h, s, l)

	local col = { 9, 0, 0 ,255};
	local C = (1.0 - math.abs(2.0*l - 1.0)) * s;

	local temp = h / 60.0;
	temp = math.fmod(temp, 2.0);
	temp = temp - 1.0;
	temp = math.abs(temp);
	temp = 1.0 - temp;
	temp = C * temp;
	local X = temp;

	local m = l - C/2.0;
	if h >= 0 and h < 60 then col[1] = C; col[2] = X; col[3] = 0;
	elseif h >= 60 and h < 120 then col[1] = X; col[2] = C; col[3] = 0;
	elseif h >= 120 and h < 180 then col[1] = 0; col[2] = C; col[3] = X; 
	elseif h >= 180 and h < 240 then col[1] = 0; col[2] = X; col[3] = C;
	elseif h >= 240 and h < 300 then col[1] = X; col[2] = 0; col[3] = C;
	elseif h >= 300 and h < 360 then col[1] = C; col[2] = 0; col[3] = X; end

	col[1] = col[1] + m;
	col[2] = col[2] + m;
	col[3] = col[3] + m;
	
	col[1] = math.floor(col[1] * 255);
	col[2] = math.floor(col[2] * 255);
	col[3] = math.floor(col[3] * 255);
	return col;
	
end

function img.cosine(a, b, x)
	ft = x * 3.1415927
	f = (1 - math.cos(ft)) * .5
	ans = a*(1-f) + b*f;
	return ans;
end

function img.linear(a, b, x)
	return a*(1-x) + b*x;
end

function avg(a,b)
	return (a+b)/2;
end

function shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function img.newLayer(pointTable)
	points2 = img.new(seed+1,img.frequency);
	for x = 1, #pointTable do
		for y = 1, #pointTable[x] do
			pointTable[x][y] = pointTable[x][y] + points2[x][y]/img.frequency;
			
		end
	end
	local temp = 1000000;
	local temp2 = -1000000;
	for x = 1, #pointTable do
		for y = 1, #pointTable[x] do
			if pointTable[x][y] < temp then
				temp = pointTable[x][y];
			end
			if pointTable[x][y] > temp2 then
				temp2 = pointTable[x][y];
			end
		end
	end
	temp2 = temp2 - temp;
	for x = 1, #pointTable do
		for y = 1, #pointTable[x] do
			pointTable[x][y] = pointTable[x][y] - temp;
			pointTable[x][y] = pointTable[x][y] / temp2
		 end
	end
	img.frequency = img.frequency * 2;
	return pointTable;
end

function img.newDetailImage(n)

	local pList = {};
	for i = 1, n do
		pList[i] = img.new(seed+i,2^i);
	end
	for x = 1, #pList[1] do
		for y = 1, #pList[1][x] do
			for i = 2, n do
				pList[1][x][y] = pList[1][x][y] + pList[i][x][y]/2^i;
			end
		end
	end
	local temp = 1000000;
	local temp2 = -100000;
	for x = 1, #pList[1] do
		for y = 1, #pList[1][x] do
			if pList[1][x][y] < temp then
				temp = pList[1][x][y];
			end
			if pList[1][x][y] > temp2 then
				temp2 = pList[1][x][y];
			end
		end
	end
	temp2 = temp2 - temp;
	for x = 1, #pList[1] do
		for y = 1, #pList[1][x] do
			pList[1][x][y] = pList[1][x][y] - temp;
			pList[1][x][y] = pList[1][x][y] / temp2;
		 end
	end
	return pList[1];
end

function img.newMandel()
    local pointTable = {};
    
    cx = img.mandel.cx;
    cy = img.mandel.cy;
    scale = img.mandel.scale;
    limit = img.mandel.limit;
    
	for x = 0, img.size do
		pointTable[x] = {};
	end
    
    for i = 0, img.mandel.maxIter do
        img.mandel.histogram[i] = 0;
    end

    for x = -1*(img.mandel.width/2), img.mandel.width/2-1 do
        for y = -1*(img.mandel.height/2), img.mandel.height/2-1 do

            ax = cx + x * scale; 
            ay = cy + y * scale;

            a1 = ax; 
            b1 = ay; 
            lp = 0;
        
            repeat
                lp = lp + 1;
                
            -- MANDELBROT SET
                a2 = a1 * a1 - b1 * b1 + ax;
                b2 = 2 * a1 * b1 + ay;
            -- Z = Z^2 - 0.8 + 0.156i
            --    a2 = a1 * a1 - b1 * b1 + -0.8;
            --    b2 = 2 * a1 * b1 + 0.156 ;
            -- Z = Z^3 + 0.400   
            --    a2 = (a1*a1*a1) - 3 * a1 * (b1 * b1) -1;
            --   b2 = (a1*a1) * b1 - (b1*b1*b1) + 2* (a1*a1) * b1;
           
                a1 = a2; 
                b1 = b2;
            until lp>img.mandel.maxIter or ((a1*a1)+(b1*b1)>limit)
       
            if lp > img.mandel.maxIter then 
                lp = 0;
            end
            img.mandel.histogram[lp] = img.mandel.histogram[lp] + 1;
            if lp < img.mandel.maxIter then
                local log_zn = math.log( a1 * a1 + b1 * b1 ) / 2;
                local nu = math.log( log_zn / math.log(2) ) / math.log(2);
                lp = lp + 1 - nu;
            end
            color1 = math.floor( lp )
            color2 = math.floor( lp + 1)
            local integral, fractional = math.modf(lp)
            color = img.linear(color1,color2, fractional);
            pointTable[x+(img.mandel.width/2)][y+(img.mandel.height/2)] = (color);
        end
    end
    return pointTable;
end

function img.setMandel(pointTable)
    img.curTable = "mandel";
	for x = 0, img.size do
		pixels[x] = {};
	end
    
    local total = 0;
    for i = 0, img.mandel.maxIter do
        total = total + img.mandel.histogram[i];
    end


    
	for x = 0, img.size - 1 do  
		for y = 0, img.size -1 do
            if pointTable[x][y] ~= nil then
                local c = pointTable[x][y];
                for i = 0, pointTable[x][y] do
                    if img.mandel.histogram[i] ~= nil then
                    c = c + (img.mandel.histogram[i] / total);
                    else
                        log.add("WTF " .. i);
                        c = 0;
                    end
                end
                
            pixels[y][x] = img.mandel.pallete[img.mandel.iPallete](c / img.mandel.maxIter);


            else
                pixels[x][y] = {0,0,0};
            end

		end
	end
end

function img.mandel.addPallete(func)
    img.mandel.pallete[img.mandel.nPallete] = func;
    img.mandel.nPallete = img.mandel.nPallete + 1;
end

function img.mandelZoom(mouseX, mouseY)
    img.mandel.cx = img.mandel.cx + img.mandel.scale * (mouseX - (img.mandel.width/2));
    img.mandel.cy = img.mandel.cy + img.mandel.scale * (mouseY - (img.mandel.height/2));
    img.mandel.scale = img.mandel.scale / 2;
end
