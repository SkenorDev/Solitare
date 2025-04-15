-- Nathan Skinner
-- CMPM 121 
-- 4-9-2025
io.stdout:setvbuf("no")
require "card"

function love.load()
  math.randomseed(os.time())
  screenWidth = 960
  screenHeight =960 
  onex=150
  twox=250
  threex=350
  fourx=450
  fivex=550
  sixx=650
  sevenx=750
  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setBackgroundColor(0.2, 0.7, 0.2, 1)
  
  back = love.graphics.newImage("Assets/back.png")
  draggingCard = nil
  deck = {}
  visible ={}
  draggable = {}
  draw = {}
  draw_done = {}
  hearts = {}
  tiles = {}
  clovers = {}
  pikes = {}
  one = {}
  two = {}
  three = {}
  four = {}
  five  = {}
  six = {}
  seven  = {}
  -- Generate full deck
  local suits = {"Hearts", "Tiles", "Clovers", "Pikes"}
  local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "A"}
  
  local scoreranks={"A","2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"}
  
  for _, suit in ipairs(suits) do
    for _, rank in ipairs(ranks) do
      local imagePath = "Assets/" .. suit .. "_" .. rank .. ".png"
      local image = nil
      if love.filesystem.getInfo(imagePath) then
        image = love.graphics.newImage(imagePath)
      end
      local card = CardClass:new(120, 200, suit, rank, image)
      table.insert(deck, card)
    end
  end
  shuffle(deck)
  start()
end

function love.update()
  
  for _, card in ipairs(draggable) do
    card:update()
  end
end

function love.draw()


  -- green rectangles
  love.graphics.setColor(0.2, 0.9, 0.2, 1)
  love.graphics.rectangle("fill", 0, 0, 100, screenHeight)
  love.graphics.rectangle("fill", screenWidth - 100, 0, 100, screenHeight)

  -- deck button
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(back, -20, 0, 0, 0.2, 0.2)
love.graphics.rectangle("line", 880, 40, 65, 90)
love.graphics.print("heart", 900, 80)
love.graphics.rectangle("line", 880, 140, 65, 90)
love.graphics.print("diamond", 900, 180)
love.graphics.rectangle("line", 880, 240, 65, 90)
love.graphics.print("clubs", 900, 280)
love.graphics.rectangle("line", 880, 340, 65, 90)
love.graphics.print("spades", 900, 380)
  for _, card in ipairs(visible) do
    card:draw()
  end
end

function love.mousepressed(x, y, button)
  check_draggable()
  if button == 1 then
    for i = #draggable, 1, -1 do
      local card = draggable[i]
      if card:isMouseOver(x, y) then
        prevx = card.position.x
        prevy = card.position.y
        originStack = card.sourceStack
        draggingCard = card
        card.isDragging = true
        card.dragOffset = Vector(x, y) - card.position
        checkvalid=false
        break
      end
    end

    if x < 100 and y < 150 then -- presses button
      printStacks()
     for i = #draw, 1, -1 do
   local card = draw[i]
   for j = #visible, 1, -1 do
  if visible[j] == card then
    table.remove(visible, j)
    break 
  end
end
  table.insert(draw_done, card)
  table.remove(draw, i)
end
if #deck<3 then
for i = #deck, 1, -1 do
      local index = 1
       local card = deck[index]
       card.sourceStack="draw"
       offset= 120*i
       card.position=Vector(20,60+offset)
       table.insert(visible, card) 
       table.insert(draw, card) 
       table.remove(deck, index)
     end
   else
     for i =3,1,-1 do
       local index = 1
       local card = deck[index]
       offset= 120*i
       card.sourceStack="draw"
       card.position=Vector(20,60+offset)
       table.insert(visible, card) 
       table.insert(draw, card) 
       table.remove(deck, index)
     end
   end
   
    end
  end
  if #deck ==0 then
    for i = 1, #draw_done do
  table.insert(deck, draw_done[i])
end
draw_done = {}
    end
end

function love.mousereleased(x, y, button)
  
  if button == 1 and draggingCard then
    draggingCard.isDragging = false
    viable(x,y)
  
  
    draggingCard.position=Vector(prevx,prevy)
    draggingCard = nil
  
  end
end

function clear(stack, card)
  for i = #stack, 1, -1 do
    if stack[i] == card then
      table.remove(stack, i)
      break
    end
  end
end
function viable(x,y)
  if x > onex - 49 and x < onex + 49 and draggingCard.sourceStack ~= "one" and checkInsert(draggingCard,one)==true then
    removeFromStack(draggingCard)  
    table.insert(one, 1,draggingCard)  
    draggingCard.sourceStack = "one"
    prevx = onex
    prevy = 100* (#one-1)
  end
 
    if x>twox-49 and x<twox+49 and draggingCard.sourceStack~="two"and checkInsert(draggingCard,two)==true then
        removeFromStack( draggingCard)
    table.insert(two,1,draggingCard)
    
    draggingCard.sourceStack="two"
    prevx=twox
    prevy=100*(#two-1)
  end 
 if x>threex-49 and x<threex+49 and draggingCard.sourceStack~="three" and checkInsert(draggingCard,three)==true then
     removeFromStack( draggingCard)
    table.insert(three,1,draggingCard)
    
    draggingCard.sourceStack="three"
    prevx=threex
    prevy=100*(#three-1)
  end
  if x>fourx-49 and x<fourx+49 and draggingCard.sourceStack~="four" and checkInsert(draggingCard,four)==true then
      removeFromStack( draggingCard)
    table.insert(four,1,draggingCard)
  
    draggingCard.sourceStack="four"
    prevx=fourx
    prevy=100*(#four-1)
  end
  if x>fivex-49 and x<fivex+49 and draggingCard.sourceStack~="five"and checkInsert(draggingCard,five)==true then
      removeFromStack( draggingCard)
    table.insert(five,1,draggingCard)
  
    draggingCard.sourceStack="five"
    prevx=fivex
    prevy=100*(#five-1)
  end
  if x>sixx-49 and x<sixx+49  and draggingCard.sourceStack~="six" and checkInsert(draggingCard,six)==true then
        removeFromStack( draggingCard)
    table.insert(six,1,draggingCard)

    draggingCard.sourceStack="six"
    prevx=sixx
    prevy=100*(#six-1)
  end
 if x>sevenx-49 and x<sevenx+49 and draggingCard.sourceStack~="seven" and checkInsert(draggingCard,seven)==true then
       removeFromStack( draggingCard)
    table.insert(seven,1,draggingCard)

    draggingCard.sourceStack="seven"
    prevx=sevenx
    prevy=100*(#seven-1)
  end
  if x>sevenx+100 and y<150 and draggingCard.sourceStack~="hearts" and checkscore(draggingCard,"Hearts")==true then
    removeFromStack( draggingCard)
    table.insert(hearts,draggingCard)
     draggingCard.sourceStack="hearts"
     prevx=sevenx+130
     prevy= 35
    end
    if x>sevenx+100 and y>150 and y<220 and draggingCard.sourceStack~="tiles" and checkscore(draggingCard,"Tiles")==true then
    removeFromStack( draggingCard)
    table.insert(tiles,draggingCard)
     draggingCard.sourceStack="tiles"
     prevx=sevenx+130
     prevy= 140
    end
    if x>sevenx+100 and y>220 and y<320 and draggingCard.sourceStack~="clovers" and checkscore(draggingCard,"Clovers")==true then
    removeFromStack( draggingCard)
    table.insert(clovers,draggingCard)
     draggingCard.sourceStack="clovers"
     prevx=sevenx+130
     prevy=235
    end
    if x>sevenx+100 and y>320 and y<420 and draggingCard.sourceStack~="pikes" and checkscore(draggingCard,"Pikes")==true then
    removeFromStack( draggingCard)
    table.insert(pikes,draggingCard)
     draggingCard.sourceStack="pikes"
     prevx=sevenx+130
     prevy= 335
    end
    check_draggable()
end
function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
end
function check_draggable()
  draggable ={}
  table.insert(draggable,draw[1])
    local possibleStacks = {draw,one, two, three, four, five, six, seven,hearts,tiles,clovers,pikes}
        for _, stack in ipairs(possibleStacks) do
          if #stack> 0 then
          stack[1].face=true
         
        end
        for _, card in ipairs(stack) do
          if card.face==true then
         table.insert(draggable,card)
         end
          end
end
end 
function start()
  for i =1,1,-1 do
    local index = 1
       local card = deck[index]
       card.face=false
       offset= 100*(i-1)
       card.sourceStack="one"
       card.position=Vector(onex,0+offset)
       table.insert(visible, card) 
       table.insert(one, card) 
       table.remove(deck, index)
    end
    for i =2,1,-1 do
    local index = 1
       local card = deck[index]
       card.face=false
       offset= 100*(i-1)
       card.sourceStack="two"
       card.position=Vector(twox,offset)
       table.insert(visible, card) 
       table.insert(two, card) 
       table.remove(deck, index)
    end
    for i =3,1,-1 do
    local index = 1
       local card = deck[index]
       card.face=false
       offset= 100*(i-1)
       card.sourceStack="three"
       card.position=Vector(threex,offset)
       table.insert(visible, card) 
       table.insert(three, card) 
       table.remove(deck, index)
    end
     for i =4,1,-1 do
    local index = 1
       local card = deck[index]
       card.face=false
       offset=100*(i-1)
       card.sourceStack="four"
       card.position=Vector(fourx,offset)
       table.insert(visible, card) 
       table.insert(four, card) 
       table.remove(deck, index)
    end
    for i =5,1,-1 do
    local index = 1
       local card = deck[index]
       card.face=false
       offset= 100*(i-1)
       card.sourceStack="five"
       card.position=Vector(fivex,offset)
       table.insert(visible, card) 
       table.insert(five, card) 
       table.remove(deck, index)
    end
    for i =6,1,-1 do
    local index = 1
       local card = deck[index]
       card.face=false
       card.sourceStack="six"
       offset= 100*(i-1)
       card.position=Vector(sixx,offset)
       table.insert(visible, card) 
       table.insert(six, card) 
       table.remove(deck, index)
    end
    for i =7,1,-1 do
    local index = 1
       local card = deck[index]
       card.face=false
       card.sourceStack="seven"
       offset=100*(i-1)
       card.position=Vector(sevenx,offset)
       table.insert(visible, card) 
       table.insert(seven, card) 
       table.remove(deck, index)
    end
    check_draggable()
  end
function removeFromStack(card)
  local possibleStacks = {draw,one, two, three, four, five, six, seven,hearts,tiles,clovers,pikes}
  for _, stack in ipairs(possibleStacks) do
    for i = #stack, 1, -1 do
      if stack[i] == card then
        table.remove(stack, i)
        return
      end
    end
  end
end

function checkscore(card,suit)
  local rankIndex = {
  ["2"] = 1,
  ["3"] = 2,
  ["4"] = 3,
  ["5"] = 4,
  ["6"] = 5,
  ["7"] = 6,
  ["8"] = 7,
  ["9"] = 8,
  ["10"] = 9,
  ["Jack"] = 10,
  ["Queen"] = 11,
  ["King"] = 12,
  ["A"] = 0
}
if card.suit == "Clovers" then
  if rankIndex[card.rank]~=#clovers then
    return false
  end
end
if card.suit == "Tiles" then
  if rankIndex[card.rank]~=#tiles  then
    return false
  end
end
if card.suit == "Hearts" then
  if rankIndex[card.rank]~=#hearts then
    return false
  end
end
if card.suit == "Pikes" then
  if rankIndex[card.rank]~=#pikes  then
    return false
  end
  end
  if card.suit==suit then
    return true
  else 
    return false
    end
  end

function checkInsert(card,cards)
  local rankIndex = {
  ["2"] = 1,
  ["3"] = 2,
  ["4"] = 3,
  ["5"] = 4,
  ["6"] = 5,
  ["7"] = 6,
  ["8"] = 7,
  ["9"] = 8,
  ["10"] = 9,
  ["Jack"] = 10,
  ["Queen"] = 11,
  ["King"] = 12,
  ["A"] = 0
}
ccard=cards[1]
  rank=card.rank
  if rank == "King" and #cards ==0 then 
    return true
  end
  
  print(rankIndex[rank]+1,rankIndex[ccard.rank])
  if rankIndex[ccard.rank] ~=rankIndex[rank]+1 then
    return false
    end
  suit=card.suit
   
  if suit == "Clovers" or suit == "Pikes" then
   
    if ccard.suit=="Tiles" or ccard.suit=="Hearts" then
      return true
    else 
      print("NO")
      return false
      end 
    end
     if suit == "Tiles" or card.suit == "Hearts" then
   
    if ccard.suit=="Clovers" or ccard.suit== "Pikes" then
      
      return true
    else 
     

      return false
      end 
    end
  end
function printStacks()
  local stacks = {
    one = one,
    two = two,
    three = three,
    four = four,
    five = five,
    six = six,
    seven = seven
  }

  for name, stack in pairs(stacks) do
    print(name .. ":")
    for i, card in ipairs(stack) do
      print("  " .. i .. ": " .. card.rank .. " of " .. card.suit)
    end
  end
end