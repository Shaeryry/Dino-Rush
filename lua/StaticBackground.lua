local backgroundModule = require("Background")
local staticBackground = backgroundModule:new();
function staticBackground:new(path,backgroundRect,parallaxFactor)
    local staticBackgroundInstance = backgroundModule:new(); 
    staticBackgroundInstance.image = createBitmap(path);  
    staticBackgroundInstance.parallaxFactor = (parallaxFactor or 0);

    local widthTile,heightTile = getBitmapWidth(staticBackgroundInstance.image),getBitmapHeight(staticBackgroundInstance.image);
    local xScale = (backgroundRect.width/widthTile); -- Scale on the X-Axis to fill out the screen, doesn't need to be filled out on the Y axis because don't want that
    local scaledWidthTile,scaledHeightTile = (widthTile * xScale),(heightTile * xScale); 
     
    local dstRect = RECT.new();  
    dstRect.left = math.floor((backgroundRect.left) );   
    dstRect.top = math.floor((backgroundRect.top) );     
    dstRect.right = math.floor(dstRect.left + scaledWidthTile  );  
    dstRect.bottom = math.floor(dstRect.top + scaledHeightTile );    

    local srcRect = RECT.new() 
    srcRect.left = math.floor(backgroundRect.left);  
    srcRect.top = math.floor(backgroundRect.top );   
    srcRect.right = math.floor(widthTile);    
    srcRect.bottom = math.floor(heightTile ); 

    local tile = self:createTile( 
        {
            image = staticBackgroundInstance.image;
            drawRect = dstRect;  
            srcRect = srcRect;
        }
    )
    staticBackgroundInstance:addTile(tile); 
    
    return setmetatable(staticBackgroundInstance,{__index=staticBackground;})
end

return staticBackground;