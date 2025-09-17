local sound = {};
function sound.new(path)
    local soundInstance = Audio.new("Resources/Sounds/"..path);  
    table.insert(_G.SOUNDS,soundInstance);
    
    return soundInstance;
end 

return sound; 