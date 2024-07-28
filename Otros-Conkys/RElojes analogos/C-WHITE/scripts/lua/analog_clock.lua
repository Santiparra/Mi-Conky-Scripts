--[[

Original lua script by jbaseb
http://gnome-look.org/content/show.php/Conky+Analog+Clock?content=149148
Submitted : Feb 25 2012
Updated : Feb 17 2016
Edited : April 09 2016 by Etles_Team

==And thank you somuch for the author, Inspired me to edited this script==

This is important line/section/path/images to make this lua script working as well.

image_path = os.getenv ('HOME')..'/.conky/Conky-Name/images/Images-Name/'

Default Example on my config is look like this:

image_path = os.getenv ('HOME')..'/.conky/C-WHITE/images/c-white/'

To call this lua script in conkyrc file, Add this command where
you saved this script before "TEXT", Example :

lua_load ~/.conky/C-WHITE/scripts/lua/analog_clock.lua
lua_draw_hook_post cairo_clock 200 150 150

TEXT
----------------------------------------------------------
Also you can tweak your own config for Size/Re-size and changed position analog clock.
See value after section (lua_draw_hook_post cairo_clock) before TEXT in conkyrc file.
Where :

200 = is Size analog clock
150 = is X (right/left) positioning analog clock
150 = Y (top/bottom) positioning analog clock

]]

--=================================================================--

require 'cairo'

--=================================================================--

image_path = os.getenv ('HOME')..'/.conky/C-WHITE/images/c-white/'

function conky_cairo_clock(w,x,y)

if conky_window==nil then return ' ' end

local w = w or 200
local x = x or conky_window.width / 2
local y = y or conky_window.height / 2

local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)

local function fDrawImage(path,x,y,w,h,arc)
local img =  cairo_image_surface_create_from_png(path)
local w_img, h_img = cairo_image_surface_get_width (img), cairo_image_surface_get_height (img)

local cr = cairo_create (cs)
cairo_translate (cr, x, y)
if arc then
cairo_rotate (cr, arc)
end
cairo_scale (cr, w/w_img, h/h_img)
cairo_set_source_surface (cr, img, -w_img/2, -h_img/2)

cairo_paint (cr)
cairo_destroy(cr)
cairo_surface_destroy (img)
collectgarbage ()

end

local arc_s = (2 * math.pi / 60) * os.date("%S")
local arc_m = (2 * math.pi / 60) * os.date("%M") + arc_s / 60
local arc_h = (2 * math.pi / 12) * os.date("%I") + arc_m / 12

--==============================--
-- Analog Clock Images Sections --
--==============================--
fDrawImage(image_path..'/base.png',x,y,w,w)
fDrawImage(image_path..'/h.png',x,y,w,w,arc_h)
fDrawImage(image_path..'/m.png',x,y,w,w,arc_m)
fDrawImage(image_path..'/s.png',x,y,w,w,arc_s)

return ' '

end
--=========================== Regards, Etles_Team =======================--