

function love.draw()
	love.graphics.setBackgroundColor( 50, 50, 50 )
	love.graphics.clear()
	img.draw();
    log.draw();
	menu.draw();
end


function love.load()

	require("log");
	require("img");
	require("menu");
	W,H = love.graphics.getDimensions();
	love.graphics.setPointStyle("rough");
    
    --CREATING MENU BUTTONS
	menu.button(1200,100,100,40,"new image",
		function() 
			img.frequency = 2;
			colorTable = img.new(seed+1,img.frequency)
			img.setImg(colorTable);
		end
	);
	menu.button(1200,150,100,40,"Layer",
		function() 
			if colorTable ~= nil then
                colorTable = img.newLayer(colorTable);
                img.setImg(colorTable);
                log.add("new layer with frequency: " .. img.frequency);
            else
                log.add("Base image not found");
            end
		end
	);
    menu.button(1200,200,100,40,"Detail image",
		function() 
			
			colorTable = img.newDetailImage(6);
			img.setImg(colorTable);
		end
	);
    menu.button(1310,100,100,40,"New Mandelbrot",
		function()
            img.mandel.cx = 0;
            img.mandel.cy = 0;
            img.mandel.scale = 0.02;
            img.mandel.limit = 10;
			mandelTable = img.newMandel();
			img.setMandel(mandelTable);
		end
	);
    menu.button(1310,150,100,40,"Max iter up",
		function() 
            img.mandel.maxIter = img.mandel.maxIter + 100;
            mandelTable = img.newMandel();
			img.setMandel(mandelTable);
			log.add("Max Iterations: " .. img.mandel.maxIter);
		end
	);
    menu.button(1310,200,100,40,"Max iter down",
		function() 
            img.mandel.maxIter = img.mandel.maxIter - 100;
            mandelTable = img.newMandel();
			img.setMandel(mandelTable);
		end
	);
    menu.button(1310,250,100,40,"Pallete",
		function() 
            img.mandel.iPallete = (img.mandel.iPallete + 1) % img.mandel.nPallete;
			img.setMandel(mandelTable);
		end
	);
    
    --CREATING NEW COLOR PALLETES
    img.mandel.addPallete(
        function(c)
            return img.hslToRgb(50,c-(c^4),c-(c^4))
        end
    );
    img.mandel.addPallete(
        function(c)
            return img.hslToRgb(10,(math.cos(c*100)/2)+0.5,c^4)
        end
    );
    img.mandel.addPallete(
        function(c)
            return img.hslToRgb(c^4*360,c^4,c^4)
        end
    );
    img.mandel.addPallete(
        function(c)
            return img.hslToRgb(10,c^4,c^4)
        end
    );
    img.mandel.addPallete(
        function(c)
            return img.hslToRgb(200,c^4,c^4);
        end
    );
    img.mandel.addPallete(
        function(c)
            return img.hslToRgb(255*c,c^4,c^4)
        end
    );

	img.new(1,img.frequency);

end

function love.mousepressed(x,y, button)
	if button == "wu" then
		log.start = math.max(math.min(log.start + 1, #log.entries - (log.max-1)),1);
	elseif button == "wd" then
		log.start = math.max(log.start - 1, 1);
	elseif button ==  "l" then
        menu.isClicked(x,y);
        if img.curTable == "mandel" then
            if x > 0 and x < img.mandel.width and y > 0 and y < img.mandel.height then
                img.mandelZoom(x,y);
                mandelTable = img.newMandel(0,0,0.02,4);
                img.setMandel(mandelTable);
            end
        end
	end
end

function love.keypressed(key,isrepeat)
	
	if key == "return" then
		img.new(seed+1);
		log.add("new image");
	elseif key == "kp+" then
		img.frequency = img.frequency+1;
        img.mandel.maxIter = img.mandel.maxIter + 100;
		log.add("frequency: " .. img.frequency);
	elseif key == "kp-" then
		img.frequency = img.frequency-1;

		log.add("frequency: " .. img.frequency);
	end
end

