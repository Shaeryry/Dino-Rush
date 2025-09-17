package.path = "./?.lua;"..package.path;
local GAME_NAME = "DINO RUSH" 

-- Globals
_G.SOUNDS = {};
_G.TEXTURES = {};
_G.SHOW_HITBOXES = false;
_G.SHOW_DRAW_RECT = false; 

_G.WINDOW_WIDTH = 800; 
_G.WINDOW_HEIGHT = 350;  
_G.FLOOR_HEIGHT = (_G.WINDOW_HEIGHT - 50); -- Floor level 
 
-- Modules 
_G.GAME_STARTED = false;
local totalElapsedTime = 0; 
local SaveModule = require("Save");
local soundModule = require("Sound");

local floorBackgroundModule = require("FloorBackground");
local staticBackgroundModule = require("StaticBackground"); 

local dinoClass = require("Dino"); 
local cactusClass = require("Cactus");
local birdClass = require("Bird");

-- Game variables
local SaveFile = SaveModule:new("dinosaurSave.txt");

local backgrounds = {};
local WINDOW_WIDTH = _G.WINDOW_WIDTH; 
local WINDOW_HEIGHT = _G.WINDOW_HEIGHT;
local FLOOR_HEIGHT = _G.FLOOR_HEIGHT;

local isGameOver = false; 
local dino = {}; 

local score = 0;
local highscore = 0;
local scoreIncrease = 10;

local entities = {};
local enemies = {};
local minSpawnOffset,maxSpawnOffset = 0,1200;

-- Cactus settings
local cactusSpeed = 350;
local birdSpeed = 400;
--
 
local spawnInterval = 3
local spawnTimer = 0

local gameLevel = 0;
local levelUpIndicatorLength = 1;
local levelUpClock = levelUpIndicatorLength;

local gameSpeed = 1; 

local startSound = soundModule.new("start.wav"); 
local musicSound = soundModule.new("windmill isle.mp3"); -- Thanks to Remibee/Daphny Huys <3 
musicSound:setRepeat(true);
musicSound:setVolume(5);

-- Functions to start the game

local function createBackgrounds()
    local BACKGROUND_RECT = { 
        left = 0;
        top = 0;  
        width = _G.WINDOW_WIDTH*1.25;
        height = _G.WINDOW_HEIGHT*1.25; 
    }   
   
    local BACKGROUND = staticBackgroundModule:new("Background.png",BACKGROUND_RECT,0.005);
    local CLOUDS_BACKGROUND = staticBackgroundModule:new("Clouds.png",BACKGROUND_RECT,0.01);
    local FAR_MOUNTAIN_BACKGROUND = staticBackgroundModule:new("Far-Mountains.png",BACKGROUND_RECT,0.02);
    local MOUNTAIN_BACKGROUND = staticBackgroundModule:new("Mountains.png",BACKGROUND_RECT,.08);
 
    local FLOOR_BACKGROUND = floorBackgroundModule:new({x=0,y=_G.FLOOR_HEIGHT}); 

    table.insert(backgrounds,BACKGROUND);
    table.insert(backgrounds,CLOUDS_BACKGROUND);
    table.insert(backgrounds,FAR_MOUNTAIN_BACKGROUND);
    table.insert(backgrounds,MOUNTAIN_BACKGROUND);
    table.insert(backgrounds,FLOOR_BACKGROUND);
end
local function createDino()
    if (not dino.created) then
        dino = dinoClass:new(
            {
                position = {x = 50; y = FLOOR_HEIGHT};
                gravity = 1500;
                jumpPower = 600;
                
                width = 30; 
                height = 40;

                rectWidth = 45;
                rectHeight= 45;
            }
        );

        dino:hatch();
    end

    table.insert(entities,dino); 
end
local function loadData()
    -- Highscore and data management
    local savedData = SaveFile:read();
    if (savedData) then
        highscore = savedData.highscore;
    end
end
local function startGame();
    loadData();
 
    isGameOver = false;
    enemies = {};
    entities = {};
    spawnTimer = 0; 
    score = 0;
    gameSpeed = 1;

    createDino();
    musicSound:play(0,-1);
end
local function endGame()
    musicSound:stop();
    isGameOver = true;

    local newHighscore = math.floor((score > highscore) and score or highscore);
    local saveableData = {
        highscore = newHighscore;
    };

    SaveFile:save(saveableData);
end
 
-- Functions to spawn enemy entities 
local function getRandomizedX()
    local spawnOffset = math.random(minSpawnOffset,maxSpawnOffset);
    return (WINDOW_WIDTH + spawnOffset)
end
local function spawnCactus() 
    local scale = math.random(100,150)/100; 
    local cactus = cactusClass:new({position={x=getRandomizedX();y=FLOOR_HEIGHT}; width=20*scale; height=40*scale; rectWidth = 64*scale;rectHeight=64*scale; speed = cactusSpeed});
    table.insert(enemies, cactus);
    table.insert(entities, cactus);
end
local function spawnBird()
    local randomizer = math.random(1,3);
    local minHeight,midHeight,maxHeight = 5,(dino.height/2) + 5,(dino.height*1.5);

    local randomizedHeight =  
        randomizer == 1 and maxHeight 
        or randomizer == 2 and midHeight
        or minHeight;

    local bird = birdClass:new({position= {x=getRandomizedX(); y=FLOOR_HEIGHT - randomizedHeight}; width=40; height=20; rectWidth = 64*1.5; rectHeight=24*1.5; speed = birdSpeed});
    table.insert(enemies, bird);
    table.insert(entities, bird);
end 

function initialize()
    setWindowTitle(GAME_NAME); 
    setWindowSize(WINDOW_WIDTH,WINDOW_HEIGHT); 
end  
function start()
    createBackgrounds();
    startGame();
end   
local function updateSpawner(elapsedSec)
    if not _G.GAME_STARTED then return end
    local spawners = {spawnCactus,spawnBird};

    spawnTimer = spawnTimer + elapsedSec * gameSpeed;
    if (spawnTimer >= spawnInterval) then 

        local selectedSpawner = spawners[math.random(1,#spawners)];
        if (selectedSpawner) then
            selectedSpawner();
        end

        spawnTimer = 0
    end
end
local function updateSounds(elapsedSec)
    for _,audio in ipairs(_G.SOUNDS) do
        audio:tick();
    end
end
local function updateScore(elapsedSec)
    if not _G.GAME_STARTED then return end
    -- Increase score and game speed
    score = score + elapsedSec * scoreIncrease * gameSpeed;

    -- Check if the level increased !
    local currentLevel = gameLevel; 
    gameLevel = math.floor( score/100 ); 

    if (currentLevel < gameLevel) then
        gameSpeed = gameSpeed + 0.05
        levelUpClock = 0;
        dino.sounds.levelUp:play(0,-1);
    end

    levelUpClock = levelUpClock + elapsedSec;
end
local function updateGame(elapsedSec)
    if not dino then return end 
    if isGameOver then return end
        
    -- Spawn enemies
    updateSpawner(elapsedSec); 

    for i,entity in pairs(entities) do
        entity:update(elapsedSec,gameSpeed);  
    end
    -- Enemy logic
    for i, enemy in ipairs(enemies) do         
        -- Remove entity that go off-screen
        if (enemy.position.x + enemy.width) < 0 then  
            table.remove(enemies, i);
            table.remove(entities,table.find(enemy)); 
        end

        if (enemy:isOverlapping(dino)) then
            dino.sounds.hurt:play(0,-1);
            endGame();
        end
    end

    updateScore(elapsedSec);
end
function keyboardUpdate()
    -- Start key
    if (isKeyDown("R")) then
        if not _G.GAME_STARTED then
            startSound:play(0,-1);
            _G.GAME_STARTED = true;
        end

        if (isGameOver) then
            startSound:play(0,-1);
            startGame();
        end
    end

    -- Dino Controls 
    if (_G.GAME_STARTED and not isGameOver) then
        if (isKeyDown("Z") or isKeyDown("W")) then
            dino:jump(); 
        end  
    
        dino:crouch(isKeyDown("S"));
    end

end 
function update(elapsedSec) 
    totalElapsedTime = totalElapsedTime + elapsedSec;
    updateSounds(elapsedSec); 
    updateGame(elapsedSec)
end 
local function drawStart()
    local currentSine = math.sin( (2 * math.pi) * (totalElapsedTime/3) );
    local yOffset = 5 * math.abs(( currentSine ) );
    local textWidth,textHeight = 500,30;

    local textRect = RECT.new(); 
    textRect.left = math.floor(20 );
    textRect.top = math.floor((WINDOW_HEIGHT - (textHeight)) + yOffset ); 
    textRect.right = math.floor(textRect.left + textWidth);  
    textRect.bottom = math.floor(textRect.top + textHeight); 

    setColor(255,255,255);
    local scoreText = drawString("Press 'R' to start running, Press 'W' to jump and 'S' to crouch !",textRect);
end
local function drawGameOver()
    local textWidth,textHeight = 150,30;

    local textRect = RECT.new(); 
    textRect.left = math.floor((WINDOW_WIDTH/2) - (textWidth/2) );
    textRect.top = math.floor((WINDOW_HEIGHT/2) - (textHeight/2)  ); 
    textRect.right = math.floor(textRect.left + textWidth );  
    textRect.bottom = math.floor(textRect.top + textHeight ); 

    setColor(0,0,0); 
    local scoreText = drawString("GAME OVER !\n Press 'R' to restart !",textRect); 
end    

local function drawGameUI(...)
    -- Draw texts and stuff
    setColor(255,255,255);  

    local textWidth,textHeight = 50,30;
    local scoreString = tostring(math.floor(score));

    local textRect = RECT.new();
    textRect.left = math.floor(WINDOW_WIDTH - (textWidth) );
    textRect.top = math.floor(WINDOW_HEIGHT - (textHeight) ); 
    textRect.right = math.floor(textRect.left + textWidth);  
    textRect.bottom = math.floor(textRect.top + textHeight); 

    local highScoreRect = RECT.new();
    highScoreRect.left = math.floor(WINDOW_WIDTH - (textWidth * 2) - 12 );
    highScoreRect.top = math.floor(WINDOW_HEIGHT - (textHeight) );
    highScoreRect.right = math.floor(textRect.left + textWidth);  
    highScoreRect.bottom = math.floor(textRect.top + textHeight); 
  
    setColor(175,175,175);  
    local highScoreText = drawString("HI "..tostring(highscore),highScoreRect);

    setColor(255,255,255);  
    local flashing = (math.sin((2 * math.pi) * (totalElapsedTime/0.2) ) > 0) and (levelUpClock < levelUpIndicatorLength)
    if (flashing) then setColor(255,255,0); end  
         
    local scoreText = drawString(scoreString,textRect); 
end 


local function drawGame()
    fillWindowRect(0,0,0);

    -- Draw Backgrounds
    local sourcePosition = {
        x = 200 * (score/100);
        y = dino.position.y
    }

    for _,background in ipairs(backgrounds) do   
        background:draw(sourcePosition); 
    end 

    -- Draw entities
    local drawQueue = entities;
    table.sort(drawQueue,function(a, b)
        return (a.position.y + a.rectHeight) > (b.position.y + b.rectHeight)
    end)

    for _, entity in ipairs(drawQueue) do 
        entity:draw();  
    end

    drawGameUI();
end 
function draw()
    drawGame();
    if not _G.GAME_STARTED then drawStart() end
    if (isGameOver) then drawGameOver() end;
end 
