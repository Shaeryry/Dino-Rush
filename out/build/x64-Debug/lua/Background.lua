local background = {}

function background:new()
	local backgroundInstance = {
		tiles = {},
		parallaxFactor = 0,
	}

	return setmetatable(backgroundInstance, { __index = self })
end

function background:createTile(parameters)
	return {
		image = parameters and parameters.image or nil,
		drawRect = parameters and parameters.drawRect or RECT.new(),
		srcRect = parameters and parameters.srcRect or RECT.new(),
	}
end

function background:addTile(tile)
	table.insert(self.tiles, tile)
end

function background:update(elapsedSec) end

function background:draw(sourcePosition)
	for tileIndex, tile in pairs(self.tiles) do
		local horizonalDisplacement = sourcePosition.x * self.parallaxFactor
		local verticalDisplacement = sourcePosition.y * self.parallaxFactor * 0.5

		local parallaxDstRect = RECT.new()
		parallaxDstRect.left = math.floor(tile.drawRect.left - horizonalDisplacement)
		parallaxDstRect.top = math.floor(tile.drawRect.top - verticalDisplacement)
		parallaxDstRect.right = tile.drawRect.right
		parallaxDstRect.bottom = tile.drawRect.bottom

		local successDraw = drawBitmapDestinationAndSource(tile.image, parallaxDstRect, tile.srcRect)
	end
end

return background
