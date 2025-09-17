local soundModule = require("Sound")
local entityModule = require("Entity")
local dino = entityModule:new({});

function dino:new(parameters)
    local dinoInstance = entityModule:new(parameters); 
    -- Instansiation 
    dinoInstance.created = true;
    dinoInstance.gravity = parameters and parameters.gravity or 0;
    dinoInstance.jumpPower = parameters and parameters.jumpPower or 0; 
    dinoInstance.velocity = { x=0; y=0 };
    dinoInstance.grounded = true;
    dinoInstance.crouched = false;

    -- initialize animation controller 
    dinoInstance.animationController:loadImage("Dino.png"); -- Load the bitmap
    dinoInstance.dinoAnimations = {
        idle = dinoInstance.animationController:play({index=0;frameCount=3;frameWidth=24;frameHeight=24;looped=true;});
        run = dinoInstance.animationController:play({index=1;frameCount=6;frameWidth=24;frameHeight=24;looped=true;priority=1;visible=false});
        crouch = dinoInstance.animationController:play({index=2;frameCount=6;frameWidth=24;frameHeight=24;looped=true;priority=2;visible=false;});
    };

    dinoInstance.sounds = {
        jump = soundModule.new("jump.wav");  
        hurt = soundModule.new("hurt.wav");
        levelUp = soundModule.new("levelUp.wav");
        land = soundModule.new("land.wav");
        crouch = soundModule.new("crouch.wav");
        eggCrack = soundModule.new("crackEgg.wav");
        hatch = soundModule.new("hatch.wav");
    };


    return setmetatable(dinoInstance,{__index=dino});
end 
   
 function dino:update(elapsedSec) 
    self.animationController:update(elapsedSec); 

      -- Update dino position
    self.velocity.y = self.velocity.y + self.gravity * elapsedSec;
    self.position.y = self.position.y + self.velocity.y * elapsedSec;

    -- Update dino grounded 
    local floorHeight = (_G.FLOOR_HEIGHT - self.height)
    local onGround = (self.position.y >= floorHeight);
  
    if (onGround) then
        self.position.y = floorHeight; 
        self.velocity.y = 0;  
    end

    if (not self.grounded and onGround) then -- Check if you landed
        self.sounds.land:play(0,-1);
    end
    
    self.grounded = onGround;  
    self.dinoAnimations.run.paused = not onGround; -- Make it so your run animation is paused in the air
    self.dinoAnimations.run.visible = _G.GAME_STARTED; -- Make it so you're not running while the game didn't start
end
 
function dino:jump()
    if (self.grounded and not self.crouched) then 
        self.sounds.jump:play(0,-1); 

        local jumpAnimation = self.animationController:play({index=3;frameCount=4;length=0.3;frameWidth=24;frameHeight=24;looped=false;priority=2})
        self.velocity.y = -self.jumpPower;
        self.grounded = false;  
    end
end

function dino:crouch(state)
    if (state and not self.crouched) then
        self.offsetY = (self.height/2);
        self.velocity.y = (self.jumpPower); -- Add velocity to fall faster

        self.dinoAnimations.crouch.visible = true;
        self.sounds.crouch:play(0,-1);
    elseif (not state and self.crouched) then
        self.dinoAnimations.crouch.visible = false;
        self.offsetY = 0;
    end

    self.crouched = state;
end
 
function dino:hatch() 

    local function reset()
        self.dinoAnimations.idle.visible = true;
        self.sounds.hatch:play(0,-1)
    end
    local function eggHatch()
        self.animationController:play({index=6;frameCount=4;frameWidth=24;frameHeight=24; callback = reset;priority=6 });
    end
    local function eggCrack() 
        self.animationController:play({index=5;frameCount=4;frameWidth=24;frameHeight=24;callback = eggHatch;priority=5 });
        self.sounds.eggCrack:play(0,-1)
    end
    local function eggStart()
        self.dinoAnimations.idle.visible = false;
        self.animationController:play({index=4;frameCount=4;frameWidth=24;frameHeight=24; callback = eggCrack ;priority=4 }); 
    end

    eggStart();
end

return dino;