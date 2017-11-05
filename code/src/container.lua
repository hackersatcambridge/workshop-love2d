local class = require 'code/lib/middleclass'

Container = class('Container')

function Container:initialize()
	self.contents = {}
end

function Container:update(dt)
	for i=#self.contents, 1, -1 do
		self.contents[i]:update(dt)
		if self.contents[i].to_delete then
			table.remove(self.contents, i)
		end
	end
end

function Container:draw()
	for i=1,#self.contents do
		self.contents[i]:draw()
	end
end

function Container:add(item)
	table.insert(self.contents, item)
end