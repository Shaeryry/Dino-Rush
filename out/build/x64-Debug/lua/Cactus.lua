local obstacleModule = require("Obstacle");
local cactus = obstacleModule:new({});  

function cactus:new(parameters)
    local cactusInstance = obstacleModule:new(parameters);
    -- initialize animation controller
    cactusInstance.animationController:loadImage("Cactus.png"); -- Load the bitmap
    local idleAnimation = cactusInstance.animationController:play({index=math.random(0,8);frameCount=1;frameWidth=64;frameHeight=64;looped=true;});

    return setmetatable(cactusInstance,{__index=cactus}); 
end 

return cactus;
 