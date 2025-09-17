
local animationControllerModule = require("AnimationController")
local entity = {}
function entity:new(parameters)
    local instance = {
        -- Members
        animationController = animationControllerModule:new();
        color = parameters and parameters.color or {r = 255,g = 0,b = 255};
        position = parameters and parameters.position or { x=0; y=0 };
        
        width = parameters and parameters.width or 0;
        height = parameters and parameters.height or 0;

        offsetX = 0;
        offsetY = 0;

        rectWidth = parameters and parameters.rectWidth or 0;
        rectHeight = parameters and parameters.rectHeight or 0;

        rectOffsetX = 0;
        rectOffsetY = 0;
    };

    instance.rectOffsetY = (instance.rectHeight - instance.height);

    return setmetatable(instance,{__index=self});
end

function entity:getHitbox()
    return {
        x = (self.position.x + self.offsetX);
        y = (self.position.y + self.offsetY);
        width = self.width;
        height = self.height;
    } 
end 
function entity:isOverlapping(other)
    local A = self:getHitbox();
    local B = other:getHitbox();

    return A.x < (B.x + B.width) and
        (A.x + A.width) > B.x and
        A.y < (B.y + B.height) and
        (A.y + A.height) > B.y
end 

function entity:draw()
    -- Draw Rect
     
    local x,y = (self.position.x + self.rectOffsetX),(self.position.y - self.rectOffsetY)
    local dstRect = RECT.new();    
    dstRect.left = math.floor(x );  
    dstRect.top  = math.floor(y );    
    dstRect.right = math.floor(x + self.rectWidth);   
    dstRect.bottom = math.floor(y + self.rectHeight);  

    if (_G.SHOW_DRAW_RECT) then 
        setColor(255,0,255);
        fillRect(dstRect.left,dstRect.top,dstRect.right, dstRect.bottom);
    end

    self.animationController:draw(dstRect); 

    -- Hitbox 
    
    if (_G.SHOW_HITBOXES) then 
        local hitbox = self:getHitbox(); 

        setColor(255,0,0);
        drawRect(hitbox.x,hitbox.y,(hitbox.x + hitbox.width), (hitbox.y + hitbox.height)); 
    end
end

return entity