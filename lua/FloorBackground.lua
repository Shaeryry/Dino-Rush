local backgroundModule = require("Background")
local floorBackground = backgroundModule:new();

function floorBackground:new(origin)
    local floorBackgroundInstance = backgroundModule:new();
    
    -- Images 
    local topTileImage = createBitmap("FloorTop.png");
    local underTileImage = createBitmap("FloorUnder.png");  
    -- Create tile map
    local widthTile = 16;
    local heightTile = 16;
 
    local tilesOnX = (_G.WINDOW_WIDTH / widthTile );
    local tilesOnY = (  math.abs(_G.FLOOR_HEIGHT - _G.WINDOW_HEIGHT) / heightTile );

    for x = 0,(tilesOnX) do  
        for y = 0,(tilesOnY) do 
            local dstRect = RECT.new(); 
            dstRect.left = math.floor(origin.x + (widthTile * x) ); 
            dstRect.top = math.floor(origin.y + (heightTile * y) );  
            dstRect.right = math.floor(dstRect.left + widthTile ); 
            dstRect.bottom = math.floor(dstRect.top + heightTile );

            local srcRect = RECT.new()
            srcRect.left = 0; 
            srcRect.top = 0; 
            srcRect.right = widthTile;    
            srcRect.bottom = heightTile;

            local tile = self:createTile(
                {
                    image = y < 1 and topTileImage or underTileImage; 
                    drawRect = dstRect; 
                    srcRect = srcRect; 
                }
            )

            floorBackgroundInstance:addTile(tile);
        end
    end 

    return setmetatable(floorBackgroundInstance,{__index=floorBackground});
end

return floorBackground;