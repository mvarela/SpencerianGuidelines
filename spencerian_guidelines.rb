#!/usr/bin/env ruby
require 'prawn'
require 'prawn/measurement_extensions'

def stave (x_height, page_width, cursor, main_slant)
	separation = 15
	slant = (main_slant/180.0)*Math::PI
	join_slant = ((main_slant-22)/180.0)*Math::PI
	stroke_color "000000" 
	stroke do
		horizontal_line 0, page_width, :at => cursor
		horizontal_line 0, page_width, :at => (cursor + x_height)
	end
	stroke_color "aaaaaa" 
	stroke do
		horizontal_line 0, page_width, :at => (cursor + 3*x_height)
		horizontal_line 0, page_width, :at => (cursor - 2*x_height)
	end
	stroke do
		stroke_color "aaaaff" 
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
	stroke_color "ffaaaa" 
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

def do_page(page_height, page_width, x_height, slant)
	font_size(9)
	text "Spencerian #{x_height/1.mm}mm, #{slant} degrees"
	self.line_width = 0.1.mm
	move_down 2.cm
	stave_height = 5.5 * x_height
	total_staves = (page_height / stave_height).to_i - 1
	total_staves.times do |i|
		stave(x_height, page_width, i*stave_height, slant)
		move_down stave_height
	end

end


x_height = ARGV[0]
slant = ARGV[1]
Prawn::Document.generate("Spencerian_#{x_height}mm_#{slant} degrees.pdf", {:page_size=>"A4"} ) do
	do_page	290.mm, 185.mm, x_height.to_f.mm, slant.to_f
end	
