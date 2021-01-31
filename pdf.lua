
PDF = {}
PDF.new = function()
	local pdf = {}		-- instance variable
	local page = {}		-- array of page descriptors
	local object = {}	-- array of object contents
	local xref_table_offset	-- byte offset of xref table

	local catalog_obj	-- global catalog object
	local pages_obj		-- global pages object
	local procset_obj	-- global procset object

	--
	-- Private functions.
	--

	local add = function(obj)
		table.insert(object, obj)
		obj.number = table.getn(object)
		return obj
	end

	local get_ref = function(obj)
		return string.format("%d 0 R", obj.number)
	end

	local write_object
	local write_direct_object
	local write_indirect_object

	write_object = function(fh, obj)
		if type(obj) == "table" and obj.datatype == "stream" then
			write_indirect_object(fh, obj)
		else
			write_direct_object(fh, obj)
		end
	end

	write_direct_object = function(fh, obj)
		if type(obj) ~= "table" then
			fh:write(obj .. "\n")
		elseif obj.datatype == "dictionary" then
			local k, v

			fh:write("<<\n")
			for k, v in pairs(obj.contents) do
				fh:write(string.format("/%s ", k))
				write_object(fh, v)
			end
			fh:write(">>\n")
		elseif obj.datatype == "array" then
			local v

			fh:write("[\n")
			for _, v in ipairs(obj.contents) do
				write_object(fh, v)
			end
			fh:write("]\n")
		elseif obj.datatype == "stream" then
			local len = 0

			if type(obj.contents) == "string" then
				len = string.len(obj.contents)
			else -- assume array
				local i, str
				
				for i, str in ipairs(obj.contents) do
					len = len + string.len(str) + 1
				end
			end

			fh:write(string.format("<< /Length %d >>\n", len))
			fh:write("stream\n")

			if type(obj.contents) == "string" then
				fh:write(obj.contents)
			else -- assume array
				local i, str
				
				for i, str in ipairs(obj.contents) do
					fh:write(str)
					fh:write("\n")
				end
			end

			fh:write("endstream\n")
		end
	end

	write_indirect_object = function(fh, obj)
		obj.offset = fh:seek()
		fh:write(string.format("%d %d obj\n", obj.number, 0))
		write_direct_object(fh, obj)
		fh:write("endobj\n")
	end

	local write_header = function(fh)
		fh:write("%PDF-1.0\n")
	end

	local write_body = function(fh)
		local i, obj
		
		for i, obj in ipairs(object) do
			write_indirect_object(fh, obj)
		end
	end

	local write_xref_table = function(fh)
		local i, obj

		xref_table_offset = fh:seek()
		fh:write("xref\n")
		fh:write(string.format("%d %d\n", 1, table.getn(object)))
		for i, obj in ipairs(object) do
			fh:write(
			    string.format("%010d %05d n \n", obj.offset, 0)
			)
		end
	end

	local write_trailer = function(fh)
		fh:write("trailer\n")
		fh:write("<<\n")
		fh:write(string.format("/Size %d\n", table.getn(object)))
		fh:write("/Root " .. get_ref(catalog_obj) .. "\n")
		fh:write(">>\n")
		fh:write("startxref\n")
		fh:write(string.format("%d\n", xref_table_offset))
		fh:write("%%EOF\n")
	end

	--
	-- Instance methods.
	--

	pdf.new_font = function(pdf, tab)
		local subtype = tab.subtype or "Type1"
		local name = tab.name or "Helvetica"
		local font_obj = add {
			datatype = "dictionary",
			contents = {
				Type = "/Font",
				Subtype = "/" .. subtype,
				BaseFont = "/" .. name,
			}
		}
		return font_obj
	end

	pdf.new_page = function(pdf)
		local pg = {}		-- instance variable
		local contents = {}	-- array of operation strings
		local used_font = {}	-- fonts used on this page

		--
		-- Private functions.
		--

		local use_font = function(font_obj)
			local i, f
			
			for i, f in ipairs(used_font) do
				if font_obj == f then
					return "/F" .. i
				end
			end
			
			table.insert(used_font, font_obj)
			return "/F" .. table.getn(used_font)
		end

		--
		-- Instance methods.
		--

		--
		-- Text functions.
		--

		pg.begin_text = function(pg)
			table.insert(contents, "BT")
		end

		pg.end_text = function(pg)
			table.insert(contents, "ET")
		end

		pg.set_font = function(pg, font_obj, size)
			table.insert(contents,
			    string.format("%s %f Tf",
			        use_font(font_obj), size)
			)
		end

		pg.set_text_pos = function(pg, x, y)
			table.insert(contents,
			    string.format("%f %f Td", x, y)
			)
		end

		pg.show = function(pg, str)
			table.insert(contents,
			    string.format("(%s) Tj", str)
			)
		end

		pg.set_char_spacing = function(pg, spc)
			table.insert(contents,
			    string.format("%f Tc", spc)
			)
		end

		--
		-- Graphics - path drawing functions.
		--

		pg.moveto = function(pg, x, y)
			table.insert(contents,
			    string.format("%f %f m", x, y)
			)
		end

		pg.lineto = function(pg, x, y)
			table.insert(contents,
			    string.format("%f %f l", x, y)
			)
		end

		pg.curveto = function(pg, x1, y1, x2, y2, x3, y3)
			local str

			if x3 and y3 then
				str = string.format("%f %f %f %f %f %f c",
				x1, y1, x2, y2, x3, y3)
			else
				str = string.format("%f %f %f %f v",
				x1, y1, x2, y2)
			end
			
			table.insert(contents, str)
		end

		pg.rectangle = function(pg, x, y, w, h)
			table.insert(contents,
			    string.format("%f %f %f %f re",
			    x, y, w, h)
			)
		end

		--
		-- Graphics - colours.
		--

		pg.setgray = function(pg, which, gray)
			assert(which == "fill" or which == "stroke")
			assert(gray >= 0 and gray <= 1)
			if which == "fill" then
				table.insert(contents,
				    string.format("%d g", gray)
				)
			else
				table.insert(contents,
				    string.format("%d G", gray)
				)
			end
		end

		pg.setrgbcolor = function(pg, which, r, g, b)
			assert(which == "fill" or which == "stroke")
			assert(r >= 0 and r <= 1)
			assert(g >= 0 and g <= 1)
			assert(b >= 0 and b <= 1)
			if which == "fill" then
				table.insert(contents,
				    string.format("%f %f %f rg", r, g, b)
				)
			else
				table.insert(contents,
				    string.format("%f %f %f RG", r, g, b)
				)
			end
		end

		pg.setcmykcolor = function(pg, which, c, m, y, k)
			assert(which == "fill" or which == "stroke")
			assert(c >= 0 and c <= 1)
			assert(m >= 0 and m <= 1)
			assert(y >= 0 and y <= 1)
			assert(k >= 0 and k <= 1)
			if which == "fill" then
				table.insert(contents,
				    string.format("%f %f %f %f k", c, m, y, k)
				)
			else
				table.insert(contents,
				    string.format("%f %f %f %f K", c, m, y, k)
				)
			end
		end

		--
		-- Graphics - line options.
		--

		pg.setflat = function(pg, i)
			assert(i >= 0 and i <= 100)
			table.insert(contents,
			    string.format("%d i", i)
			)
		end

		pg.setlinecap = function(pg, j)
			assert(j == 0 or j == 1 or j == 2)
			table.insert(contents,
			    string.format("%d J", j)
			)
		end

		pg.setlinejoin = function(pg, j)
			assert(j == 0 or j == 1 or j == 2)
			table.insert(contents,
			    string.format("%d j", j)
			)
		end

		pg.setlinewidth = function(pg, w)
			table.insert(contents,
			    string.format("%d w", w)
			)
		end

		pg.setmiterlimit = function(pg, m)
			assert(m >= 1)
			table.insert(contents,
			    string.format("%d M", m)
			)
		end

		pg.setdash = function(pg, array, phase)
			local str = ""
			local v
			
			for _, v in ipairs(array) do
				str = str .. v .. " "
			end

			table.insert(contents,
			    string.format("[%s] %d d", str, phase)
			)
		end

		--
		-- Graphics - path-terminating functions.
		--

		pg.stroke = function(pg)
			table.insert(contents, "S")
		end

		pg.closepath = function(pg)
			table.insert(contents, "h")
		end

		pg.fill = function(pg)
			table.insert(contents, "f")
		end

		pg.newpath = function(pg)
			table.insert(contents, "n")
		end

		pg.clip = function(pg) -- no effect until next newpath
			table.insert(contents, "W")
		end

		--
		-- Graphics - state save/restore.
		--

		pg.save = function(pg)
			table.insert(contents, "q")
		end

		pg.restore = function(pg)
			table.insert(contents, "Q")
		end

		--
		-- Graphics - CTM functions.
		--
		pg.transform = function(pg, a, b, c, d, e, f) -- aka concat
			table.insert(contents,
			    string.format("%f %f %f %f %f %f cm",
			        a, b, c, d, e, f)
			)		
		end

		pg.translate = function(pg, x, y)
			pg:transform(1, 0, 0, 1, x, y)
		end

		pg.scale = function(pg, x, y)
			if not y then y = x end
			pg:transform(x, 0, 0, y, 0, 0)
		end

		pg.rotate = function(pg, theta)
			local c, s = math.cos(theta), math.sin(theta)
			pg:transform(c, s, -1 * s, c, 0, 0)
		end

		pg.skew = function(pg, tha, thb)
			local tana, tanb = math.tan(tha), math.tan(thb)
			pg:transform(1, tana, tanb, 1, 0, 0)
		end

		pg.add = function(pg)
			local contents_obj, this_obj, resources
			local i, font_obj

			contents_obj = add {
				datatype = "stream",
				contents = contents
			}

			resources = {
				datatype = "dictionary",
				contents = {
					Font = {
						datatype = "dictionary",
						contents = {}
					},
					ProcSet = get_ref(procset_obj)
				}
			}

			for i, font_obj in ipairs(used_font) do
				resources.contents.Font.contents["F" .. i] =
				    get_ref(font_obj)
			end

			this_obj = add {
				datatype = "dictionary",
				contents = {
					Type = "/Page",
					Parent = get_ref(pages_obj),
					Contents = get_ref(contents_obj),
					Resources = resources
				}
			}
			
			table.insert(pages_obj.contents.Kids.contents,
			    get_ref(this_obj))
			pages_obj.contents.Count = pages_obj.contents.Count + 1
		end

		table.insert(page, pg)
		return pg
	end

	pdf.write = function(pdf, file)
		local fh

		if type(file) == "string" then
			fh = assert(io.open(file, "w"))
		else
			fh = file
		end

		write_header(fh)
		write_body(fh)
		write_xref_table(fh)
		write_trailer(fh)

		fh:close()
	end

	-- initialize... add a few objects that we know will exist.
	pages_obj = add {
		datatype = "dictionary",
		contents = {
			Type = "/Pages",
			Kids = {
				datatype = "array",
				contents = {}
			},
			Count = 0
		}
	}

	catalog_obj = add {
		datatype = "dictionary",
		contents = {
			Type = "/Catalog",
			Pages = get_ref(pages_obj)
		}
	}

	procset_obj = add {
		datatype = "array",
		contents = { "/PDF", "/Text" }
	}

	return pdf
end
