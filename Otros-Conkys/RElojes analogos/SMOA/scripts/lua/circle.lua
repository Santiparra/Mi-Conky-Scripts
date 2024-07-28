--[[

Clock Rings by Linux Mint (2011) reEdited by Etles_Team 2015

To call this script in conkyrc, use the following before "TEXT"
(assuming that you save this script to ~/scripts/rings.lua), Example:

    lua_load ~/.conky/Conky-Name/scripts/lua/circle.lua
    lua_draw_hook_pre clock_rings

TEXT

]]

settings_table = {
{
name='eval', arg='1', max=1,
bg_colour=0x5E4E33, bg_alpha=0,
fg_colour=0xEAEAEA, fg_alpha=1, --C3B694
x=85, y=79,
radius=2, thickness=6,
start_angle=0, end_angle=360
},
--[[{
name='time', arg='%S', max=60,
bg_colour=0x1d2b57, bg_alpha=0.6,
fg_colour=0x1d2b57, fg_alpha=0.6, --C3B694
x=85, y=79,
radius=70, thickness=5,
start_angle=0, end_angle=360
},]]

}

-- Use these settings to define the origin and extent of your clock.

clock_r=60

-- "clock_x" and "clock_y" are the coordinates of the centre of the clock, in pixels, from the top left of the Conky window.

clock_x=85
clock_y=79

hour_colour=0xEAEAEA
minute_colour=0xEAEAEA
second_colour=0xEAEAEA --C3B694
clock_alpha=0.5
 
-- Enable/Disable Second Hand?

show_seconds=true

--===================================================================================================================

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
local w,h=conky_window.width,conky_window.height
local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']
local angle_0=sa*(2*math.pi/360)-math.pi/2
local angle_f=ea*(2*math.pi/360)-math.pi/2
local t_arc=t*(angle_f-angle_0)

cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
cairo_set_line_width(cr,ring_w)
cairo_stroke(cr)
cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
cairo_stroke(cr)		
end

function conky_ring_stats()
local function setup_rings(cr,pt)
local str=''
local value=0
		
str=string.format('${%s %s}',pt['name'],pt['arg'])
str=conky_parse(str)		
value=tonumber(str)
if value == nil then value = 0 end
pct=value/pt['max']		
draw_ring(cr,pct,pt)
end

if conky_window==nil then return end
local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
local cr=cairo_create(cs)	
local updates=conky_parse('${updates}')
update_num=tonumber(updates)	
if update_num>1 then
for i in pairs(settings_table) do
setup_rings(cr,settings_table[i])
end
end
end

function draw_clock_hands(cr,xc,yc)
local secs,mins,hours,secs_arc,mins_arc,hours_arc
local xh,yh,xm,ym,xs,ys
 
secs=os.date("%S")	
mins=os.date("%M")
hours=os.date("%I")
secs_arc=(2*math.pi/60)*secs
mins_arc=(2*math.pi/60)*mins+secs_arc/60
hours_arc=(2*math.pi/12)*hours+mins_arc/12

--Line to setting Hour Hand

xh=xc+0.5*clock_r*math.sin(hours_arc)
yh=yc-0.5*clock_r*math.cos(hours_arc)
cairo_move_to(cr,xc,yc)
cairo_line_to(cr,xh,yh)
cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
cairo_set_line_width(cr,3.5)
cairo_set_source_rgba(cr,rgb_to_r_g_b(hour_colour,clock_alpha))
cairo_stroke(cr)

--Line to setting Minute Hand

xm=xc+0.8*clock_r*math.sin(mins_arc)
ym=yc-0.8*clock_r*math.cos(mins_arc)
cairo_move_to(cr,xc,yc)
cairo_line_to(cr,xm,ym)
cairo_set_line_width(cr,2)
cairo_set_source_rgba(cr,rgb_to_r_g_b(minute_colour,clock_alpha))
cairo_stroke(cr)

--Line to setting Second Hand

if show_seconds then
xs=xc+0.95*clock_r*math.sin(secs_arc)
ys=yc-0.95*clock_r*math.cos(secs_arc)
cairo_move_to(cr,xc,yc)
cairo_line_to(cr,xs,ys) 
cairo_set_line_width(cr,1)
cairo_set_source_rgba(cr,rgb_to_r_g_b(second_colour,clock_alpha))
cairo_stroke(cr)
end
end
 
function conky_clock_rings()
local function setup_rings(cr,pt)
local str=''
local value=0
 
str=string.format('${%s %s}',pt['name'],pt['arg'])
str=conky_parse(str)
value=tonumber(str)
pct=value/pt['max'] 
draw_ring(cr,pct,pt)
end
 
--Line to setting startup circle rings (default = 5s)
 
if conky_window==nil then return end
local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
local cr=cairo_create(cs) 
local updates=conky_parse('${updates}')
update_num=tonumber(updates)
 
if update_num>1 then
for i in pairs(settings_table) do
setup_rings(cr,settings_table[i])
end
end
 
draw_clock_hands(cr,clock_x,clock_y)
cair_destroy(cr)
cairo_surface_destroy(cs)
cr=nil
collectgarbage()
end
--========================= Regards, Etles_Team =========================