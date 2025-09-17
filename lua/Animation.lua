local animation = {};

function animation:new(parameters)
    local visibilityPreset = parameters and parameters.visible;
    local animationInstance = {
        -- Members
        callback = parameters and parameters.callback or nil;
        image = parameters and parameters.image or nil;
        index = parameters and parameters.index or 0;

        priority = parameters and parameters.priority or 0;
        length = parameters and parameters.length or .35;

        frameCount = parameters and parameters.frameCount or 0;
        frameWidth = parameters and parameters.frameWidth or 24; 
        frameHeight = parameters and parameters.frameHeight or 24; 

        looped = parameters and parameters.looped or false;
        visible = (visibilityPreset or visibilityPreset == nil);
        paused = false;
        stopped = false;

        animationClock = 0;
    };


    return setmetatable(animationInstance,{__index=self});
end 

function animation:stop()
    if (not self.stopped) then
        self.stopped = true; 
    end
end

function animation:hasCycled()
    return (self:getCurrentFrame() + 1) >= self.frameCount;
end
function animation:getCurrentFrame() 
    local currentFrame = (self.animationClock / self.length) * self.frameCount;   
    return math.floor(currentFrame) % self.frameCount;  
end 
function animation:hasEnded()
    return 
        (self:hasCycled() and not self.looped) 
        or self.stopped;  
end
function animation:draw(drawRect) 
    --if (self:hasEnded()) then return end;
    if (not self.visible) then return end;
    if (self.image) then 
        local frameX,frameY = (self.frameWidth * self:getCurrentFrame()),(self.frameHeight * self.index);
 
        local sourceRect = RECT.new(); 
        sourceRect.left = math.floor(frameX);    
        sourceRect.top = math.floor(frameY);   
        sourceRect.right = math.floor(self.frameWidth + frameX);     
        sourceRect.bottom = math.floor(self.frameHeight + frameY);   

        local successfulDraw = drawBitmapDestinationAndSource(self.image,drawRect,sourceRect)
    end   
end
function animation:update(elapsedSec)    
    if (self:hasEnded()) then return end;
    if (self.paused) then return end;

    self.animationClock = (self.animationClock + elapsedSec); -- Update the clock
end


return animation;