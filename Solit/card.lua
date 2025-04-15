require "vector"

CardClass = {}
CardClass.__index = CardClass

function CardClass:new(x, y, suit, rank, image)
  local card = setmetatable({}, CardClass)
  card.position = Vector(x, y)
  card.size = Vector(65, 90) -- size for mouse detection
  card.image = image
  card.suit = suit
  card.rank = rank
  card.name = suit .. "_" .. rank
  card.initialPosition = card.position
  card.isDragging = false
  card.dragOffset = Vector(0, 0)
  card.scale = 0.1
  card.sourceStack = nil
  card.face = true
  return card
end

function CardClass:isMouseOver(mx, my)
  return mx >= self.position.x and mx <= self.position.x + self.size.x and
         my >= self.position.y and my <= self.position.y + self.size.y
end

function CardClass:update()
  if self.isDragging then
    local mouse = Vector(love.mouse.getX(), love.mouse.getY())
    self.position = mouse - self.dragOffset
  end
end

function CardClass:draw()
  if self.face == true then
    love.graphics.setColor(1, 1, 1)
   love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.scale, self.scale)
  end 
  if self.face == false then
    love.graphics.setColor(0, 0, 0)
   love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.scale, self.scale)
  end 
end
