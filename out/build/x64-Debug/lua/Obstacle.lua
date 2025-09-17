local entityModule = require("Entity")
local obstacle = entityModule:new({})
function obstacle:new(parameters)
    local instance = entityModule:new(parameters); 
    instance.speed = parameters and parameters.speed or 100;

    instance.position.y = (instance.position.y - instance.height); -- Make sure the obstacle is above ground
  
    return setmetatable(instance,{__index=self}); 
end 
function obstacle:update(elapsedSec,gameSpeed)
    self.animationController:update(elapsedSec); 
    self.position.x = self.position.x - self.speed * gameSpeed * elapsedSec; 
end 

return obstacle;