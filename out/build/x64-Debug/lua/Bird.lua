local obstacleModule = require("Obstacle");
local bird = obstacleModule:new({});  
function bird:new(parameters) 
    local birdInstance = obstacleModule:new(parameters);
    birdInstance.animationController:loadImage("Bird.png"); -- Load the bitmap 
    local idleAnimation = birdInstance.animationController:play({index=3;frameCount=3;frameWidth=64;frameHeight=24;looped=true;});

    return setmetatable(birdInstance,{__index=bird});  
end  

return bird;
 