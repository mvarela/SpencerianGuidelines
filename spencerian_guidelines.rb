#!/usr/bin/env ruby
require 'prawn'
require 'prawn/measurement_extensions'

class Prawn::Document  
MAIN_LINE_COLOR  = "000000"
LIGHT_LINE_COLOR = "aaaaaa"
SLANT_LINE_COLOR = "aaaaff"
JOIN_LINE_COLOR  = "ffaaaa"


def spencerian_stave (x_height, page_width, cursor, main_slant)
	separation = 15
	slant = (main_slant/180.0)*Math::PI
	join_slant = ((main_slant-22)/180.0)*Math::PI
	stroke_color MAIN_LINE_COLOR
	stroke do
		horizontal_line 0, page_width, :at => cursor
		horizontal_line 0, page_width, :at => (cursor + x_height)
	end
	stroke_color LIGHT_LINE_COLOR
	stroke do
		horizontal_line 0, page_width, :at => (cursor + 3*x_height)
		horizontal_line 0, page_width, :at => (cursor - 2*x_height)
	end
	stroke do
		stroke_color SLANT_LINE_COLOR
		horizontal_line 0, page_width, :at => (cursor + 2*x_height)
		horizontal_line 0, page_width, :at => (cursor - x_height)
	end
	slant_lines = (page_width / separation.mm).to_i
	y2 = cursor + 3*x_height
	slant_lines.times do |i|
		x1 = (separation*i).mm
		y1 = cursor - 2*x_height
		x2 = x1 + (5*x_height / Math::tan(slant))
		stroke do
			line [x1,y1], [x2,y2]
		end
	end
	stroke_color JOIN_LINE_COLOR
	join_slant_lines = (page_width / separation.mm).to_i
	y2 = cursor + 3*x_height
	join_slant_lines.times do |i|
		x1 = (separation*i).mm + (2*x_height / Math::tan(slant))
		y1 = cursor
		x2 = x1 + (3*x_height / Math::tan(join_slant))
		stroke do
			line [x1,y1], [x2,y2]
		end
	end
end


def copperplate_stave (x_height, page_width, cursor, main_slant)
	slant = (main_slant/180.0)*Math::PI
	separation = x_height / (2 * Math::tan(slant))
	stroke_color MAIN_LINE_COLOR
	stroke do
		horizontal_line 0, page_width, :at => cursor
		horizontal_line 0, page_width, :at => (cursor + x_height)
	end
	stroke_color LIGHT_LINE_COLOR
	stroke do
		horizontal_line 0, page_width, :at => (cursor + 2.5*x_height)
		horizontal_line 0, page_width, :at => (cursor - 1.5*x_height)
	end
	stroke do
		stroke_color SLANT_LINE_COLOR
		horizontal_line 0, page_width, :at => (cursor + 1.75*x_height)
		horizontal_line 0, page_width, :at => (cursor - 0.75*x_height)
	end
	slant_lines = (page_width / separation.mm).to_i - 1
	y2 = cursor + 2.5*x_height
	slant_lines.times do |i|
		x1 = (separation*i).mm
		y1 = cursor - 1.5*x_height
		x2 = x1 + (4*x_height / Math::tan(slant))
		stroke do
			line [x1,y1], [x2,y2]
		end
	end
end

end

def do_page(page_height, page_width, x_height, slant, style)
  page_height = page_height.mm
  page_width = page_width.mm
  x_height = x_height.mm
  case style
  when :spencerian
    title = "Spencerian"
    multiplier = 5.5
  when :copperplate
    title = "Copperplate"
    multiplier = 4.5
  else
    exit(-1)
  end
  Prawn::Document.generate("#{title}_#{x_height/1.mm}mm_#{slant} degrees.pdf",{:page_size=>"A4"}) do
    font_size(9)
    text "#{title} #{x_height/1.mm}mm, #{slant} degrees"
    self.line_width = 0.1.mm
    move_down 2.cm
    stave_height = multiplier * x_height
    total_staves = ((page_height - 2.cm) / stave_height).to_i - 1
    total_staves.times do |i|
      case style
      when :spencerian then spencerian_stave(x_height, page_width, i*stave_height, slant)
      when :copperplate then copperplate_stave(x_height, page_width, i*stave_height, slant)
      end
      move_down stave_height
    end
  end
end

argstyle = ARGV[0]
x_height = ARGV[1]
slant    = ARGV[2]

style = case argstyle
      when "c" then :copperplate
      when "s" then :spencerian
      else nil
      end
exit unless style
puts x_height.to_f
do_page 290, 185, x_height.to_f, slant.to_f, style

