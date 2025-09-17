--- @meta

--- Game engine methods

--- @meta

--- Rectangle structure
--- Represents a rectangular region with integer coordinates.
--- @class RECT
--- @field left number # The left coordinate of the rectangle
--- @field top number # The top coordinate of the rectangle
--- @field right number # The right coordinate of the rectangle
--- @field bottom number # The bottom coordinate of the rectangle
RECT = {}

--- Creates a new rectangle
--- @return RECT
function RECT.new() end

--- Audio class
--- Represents an audio object with playback and control functionality. 
--- @class Audio
Audio = {}

--- Creates a new audio object
--- @param path string # Path to the audio file
--- @return Audio
function Audio.new(path) end

--- Plays the audio
--- @return nil
function Audio:play() end

--- Stops the audio playback
--- @return nil
function Audio:stop() end

--- Ticks the audio system (for internal updates)
--- @return nil
function Audio:tick() end

--- Sets whether the audio should repeat
--- @param repeatAudio boolean # true to enable repeat, false to disable
--- @return nil
function Audio:setRepeat(repeatAudio) end

--- Sets the volume of the audio
--- @param volume number # Volume level (0 to 100)
--- @return nil
function Audio:setVolume(volume) end

--- Gets the current volume of the audio
--- @return number # Volume level (0 to 100)
function Audio:getVolume() end

--- Checks if the audio is currently playing
--- @return boolean # true if playing, false otherwise
function Audio:isPlaying() end


--- Sets the window title
--- @param title string
--- @return nil
function setWindowTitle(title) end

    --- Sets the window size
    --- @param width number
    --- @param height number
    --- @return nil
    function setWindowSize(width, height) end
    
    --- Checks if a specific key has been pressed
    --- @param key string
    --- @return boolean
    function isKeyDown(key) end
    
    --- Creates a bitmap texture
    --- @param path string # Path to the texture
    --- @return userdata # Returns a pointer to the texture in C++
    function createBitmap(path) end
    
    --- Draws a bitmap texture
    --- @param bitmap userdata # Pointer to a bitmap
    --- @param left number # x position where the bitmap will be drawn
    --- @param top number # y position where the bitmap will be drawn
    --- @return boolean
    function drawBitmap(bitmap, left, top) end
    
    --- Gets a bitmap's width
    --- @param bitmap userdata # Pointer to a bitmap
    --- @return number
    function getBitmapWidth(bitmap) end
    
    --- Gets a bitmap's height
    --- @param bitmap userdata # Pointer to a bitmap
    --- @return number
    function getBitmapHeight(bitmap) end
    
    --- Draws a bitmap texture with a source rectangle
    --- @param bitmap userdata # Pointer to a bitmap
    --- @param left number
    --- @param top number
    --- @param source table # Source rectangle as {left = number, top = number, right = number, bottom = number}
    --- @return boolean
    function drawBitmapWithSource(bitmap, left, top, source) end
    
    --- Draws a bitmap texture with a destination rectangle and source rectangle
    --- @param bitmap userdata # Pointer to a bitmap
    --- @param destination table # Destination rectangle as {left = number, top = number, right = number, bottom = number}
    --- @param source table # Source rectangle as {left = number, top = number, right = number, bottom = number}
    --- @return boolean
    function drawBitmapDestinationAndSource(bitmap, destination, source) end
    
    --- Draws a string of text within a rectangle
    --- @param text string # The text to draw
    --- @param rect table # Rectangle as {left = number, top = number, right = number, bottom = number}
    --- @return boolean
    function drawString(text, rect) end
    
    --- Sets the current drawing color
    --- @param r number
    --- @param g number
    --- @param b number
    --- @return nil
    function setColor(r, g, b) end
    
    --- Fills a rectangle with the current color
    --- @param left number
    --- @param top number
    --- @param right number
    --- @param bottom number
    --- @return boolean
    function fillRect(left, top, right, bottom) end
    
    --- Draws a rectangle outline with the current color
    --- @param left number
    --- @param top number
    --- @param right number
    --- @param bottom number
    --- @return boolean
    function drawRect(left, top, right, bottom) end
    
    --- Clears the background with the specified color
    --- @param r number
    --- @param g number
    --- @param b number
    --- @return nil
    function fillWindowRect(r, g, b) end
    