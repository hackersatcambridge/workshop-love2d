--[[
Copyright (c) 2017 George Prosser

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

-- rounds num to the specified number of decimal places, 0 by default
function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- returns true with probability p
function chance(p)
    return math.random() < p
end

-- returns the angular distance between the angles a and b
function angularDistance(a, b)
    return math.abs(math.atan2(math.sin(a - b), math.cos(a - b)))
end

-- normalizes an angle to between -pi and +pi
function normalizeAngle(a)
    return a - (2 * math.pi) * math.floor((a + math.pi) / (2 * math.pi))
end

-- returns x, clamped between min and max
function clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

-- returns point at which two line segments intersect
function segmentIntersection(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y)
    local s10_x = p1_x - p0_x
    local s10_y = p1_y - p0_y
    local s32_x = p3_x - p2_x
    local s32_y = p3_y - p2_y

    local denom = s10_x * s32_y - s32_x * s10_y
    if (denom == 0) then return nil,nil end
    local denom_positive = denom > 0

    local s02_x = p0_x - p2_x
    local s02_y = p0_y - p2_y
    local s_numer = s10_x * s02_y - s10_y * s02_x
    if ((s_numer < 0) == denom_positive) then return nil,nil end

    local t_numer = s32_x * s02_y - s32_y * s02_x
    if ((t_numer < 0) == denom_positive) then return nil,nil end

    if (((s_numer > denom) == denom_positive) or ((t_numer > denom) == denom_positive)) then return nil,nil end

    local t = t_numer / denom
    return p0_x+t*s10_x, p0_y+t*s10_y
end

-- quadratic equation solver
function quadraticSolve(a, b, c)
    local discrim = math.sqrt(b^2 - 4*a*c)
    return (-b+discrim)/(2*a), (-b-discrim)/(2*a)
end

-- shuffles the elements of a table
function shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- returns a random element from supplied table
function randomElement(t)
    return t[math.random(1, #t)]
end

-- returns true if table t contains the element e
function tableContains(t, e)
    for i=1,#t do
        if t[i] == e then
            return true
        end
    end
    return false
end