local animationModule = require("Animation");
local animationController = {};

function animationController:new()
    local animationControllerInstance = {
        -- Members
        image = nil;
        loaded = false;
        animations = {};
    };

    return setmetatable(animationControllerInstance,{__index=self});
end

function animationController:loadImage(path)
    local existingBitmap = _G.TEXTURES[path];
    local loadedBitmap = existingBitmap or createBitmap(path);

    if (loadedBitmap) then
        self.loaded = true;
        self.image = loadedBitmap;

        if not existingBitmap then
            _G.TEXTURES[path] = loadedBitmap;
        end
    end

    return loadedBitmap
end

function animationController:play(animationInfo) 
    local info = animationInfo;
    info.image = self.image; -- Set the spritesheet for animations

    local animation = animationModule:new(info);
    table.insert(self.animations,animation);

    return animation;
end  
function animationController:update(elapsedSec)
    table.sort(self.animations,function(A,B) -- Sort the list so higher priority animations load !
        return (A.priority > B.priority);
    end) 
 
    local endedAnimations = {}; 
    for index,animation in pairs(self.animations) do 
        animation:update(elapsedSec); 

        if ( animation:hasEnded() ) then
            table.insert(endedAnimations,animation);
        end  
    end 

    -- Clean ended animations 
    for _,endedAnimation in pairs(endedAnimations) do  
        for animationIndex,animation in ipairs(self.animations) do
            if (animation == endedAnimation) then
                table.remove(self.animations,animationIndex);
                
                if (endedAnimation.callback) then
                    endedAnimation.callback();
                end
            end
        end
    end

end

function animationController:draw(drawRect)
    if not self.loaded then return end
        
    for animationIndex,playingAnimation in ipairs(self.animations) do
        if (playingAnimation.visible) then
            playingAnimation:draw(drawRect);
            break;
        end    
    end
    
end

return animationController;