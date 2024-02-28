-- this is essentially 
-- https://github.com/jupyter/nbconvert/blob/main/nbconvert/filters/ansi.py
-- converted to lua

-- good list of ANSI escape sequences:
-- https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797


local ANSI_COLORS = {
    "ansi-black",
    "ansi-red",
    "ansi-green",
    "ansi-yellow",
    "ansi-blue",
    "ansi-magenta",
    "ansi-cyan",
    "ansi-white",
    "ansi-black-intense",
    "ansi-red-intense",
    "ansi-green-intense",
    "ansi-yellow-intense",
    "ansi-blue-intense",
    "ansi-magenta-intense",
    "ansi-cyan-intense",
    "ansi-white-intense"
}

local function get_extended_color(numbers)
    local n = table.remove(numbers, 1)
    local r,g,b,idx
    if n == 2 and #numbers >=3 then
        -- 24bit RGB
        r = table.remove(numbers, 1)
        g = table.remove(numbers, 1)
        b = table.remove(numbers, 1)
    elseif n == 5 and #numbers >= 1 then
        -- 256 colors
        idx = table.remove(numbers, 1)
        if idx < 16 then
            -- 16 default terminal colors
            return idx
        elseif idx < 232 then
            -- 6x6x6 color cube, see http://stackoverflow.com/a/27165165/500098
            r = (idx - 16) // 36
            r = 55 + r * 40
            if r < 0 then r = 0 end
            g = ((idx - 16) % 36) // 6
            g = 55 + g * 40
            if g < 0 then g = 0 end
            b = (idx - 16) % 6
            b = 55 + b * 40
            if b < 0 then b = 0 end
        elseif idx < 256 then
            -- grayscale, see http://stackoverflow.com/a/27165165/500098
            r = (idx - 232) * 10 + 8
            g = r
            b = r
        end
    end
    return {r, g, b}
end


--[=[
local re = require "re"

local ANSI = re.compile [[
    '\x1b%[' {.*?} {[@-~]} 
    ]]

--]=]

local function LaTeXconverter(fg, bg, bold, underline, inverse)
    if not (fg or bg or bold or underline or inverse) then
        return "",""
    end

    local starttag = ""
    local endtag = ""

    if inverse then
        fg, bg = bg, fg
    end

    if type(fg) == "number" then
        starttag = starttag .. [[\textcolor{]] .. ANSI_COLORS[fg+1] .. "}{"
        endtag = "}" .. endtag
    elseif type(fg) == "table" then
        -- See http://tex.stackexchange.com/a/291102/13684
        starttag = starttag .. [[\def\tcRGB{\textcolor[RGB]}\expandafter]]
        starttag = starttag .. string.format([[\tcRGB\expandafter{\detokenize{%d,%d,%d}}{]], fg[1], fg[2], fg[3])
        endtag = "}" .. endtag
    elseif inverse then
        starttag = starttag .. [[\textcolor{ansi-default-inverse-fg}{]]
        endtag = "}" .. endtag
    end

    if type(bg) == "number" then
        starttag = starttag .. [[\setlength{\fboxsep}{0pt}]]
        starttag = starttag .. [[\colorbox{]] .. ANSI_COLORS[bg+1] .. "}{"
        endtag = [[\strut}]] .. endtag
    elseif type(bg) == "table" then
        -- See http://tex.stackexchange.com/a/291102/13684
        starttag = starttag .. [[\setlength{\fboxsep}{0pt}]]
        starttag = starttag .. [[\def\cbRGB{\colorbox[RGB]}\expandafter]]
        starttag = starttag .. string.format([[\cbRGB\expandafter{\detokenize{%d,%d,%d}}{]], bg[1], bg[2], bg[3])
        endtag = [[\strut}]] .. endtag
    elseif inverse then
        starttag = starttag .. [[\setlength{\fboxsep}{0pt}]]
        starttag = starttag .. [[\colorbox{ansi-default-inverse-bg}{]]
        endtag = [[\strut}]] .. endtag
    end

    if bold then
        starttag = starttag .. [[\textbf{]]
        endtag  = "}" .. endtag
    end

    if underline then
        starttag = starttag .. [[\underline{]]
        endtag  = "}" .. endtag
    end
    return starttag, endtag
end

local function HTMLconverter(fg, bg, bold, underline, inverse)
    if not (fg or bg or bold or underline or inverse) then
        return "",""
    end
    local classes = {}
    local styles  = {}
    local type = type  -- more efficient? 
    local next = next
    if inverse then
        fg, bg = bg, fg
    end

    if type(fg) == "number" then
        table.insert(classes, ANSI_COLORS[fg+1] .. "-fg")
    elseif type(fg) == "table" then
        table.insert(styles, string.format("color: rgb(%d,%d,%d)", fg[1], fg[2], fg[3]))
    elseif inverse then
        table.insert(classes, "ansi-default-inverse-fg")
    end

    if type(bg) == "number" then
        table.insert(classes, ANSI_COLORS[bg+1] .. "-bg")
    elseif type(bg) == "table" then
        table.insert(styles, string.format("background-color: rgb(%d,%d,%d)",
            bg[1], bg[2], bg[3]))
    elseif inverse then
        table.insert(classes, "ansi-default-inverse-bg")
    end

    if bold then
        table.insert(classes, "ansi-bold")
    end

    if underline then
        table.insert(classes, "ansi-underline")
    end

    local starttag = "<span"
    if next(classes) ~= nil   then
        starttag = starttag .. ' class="' ..  table.concat(classes, " ") .. '"'
    end

    if next(styles) ~= nil then
        starttag = starttag .. ' style="' ..  table.concat(styles, " ") .. '"'
    end

    return starttag..">","</span>"
end

   
local function codeBlockTrans(e)
    local converter, fmt
    if quarto.doc.isFormat('latex') then
        converter = LaTeXconverter
        fmt = 'latex'
    elseif quarto.doc.isFormat('html') then
        converter = HTMLconverter
        fmt = 'html'
    else
        return
    end

    -- not for input cells
    if e.classes:includes("julia") or e.classes:includes("cell-code")  then
        return
    end

    if #e.classes > 0 and not e.classes:includes("julia-stderr") then
        return
    end

    local texenv="OutputCell"
    local codeclass=""
    if string.find(e.text, "\u{a35f}\u{2983}") then
        texenv = "AnsiOutputCell"
        codeclass = "ansi"
    end
    if e.classes:includes("julia-stderr") then
        texenv = "StderrOutputCell"
        codeclass = codeclass .. " julia-stderr" -- empty leading space doesn't matter
    end

    local out=""
    -- if string.find(e.text, "\x1b%[") then
    if string.find(e.text, "\u{a35f}\u{2983}") then
        local bold = false
        local underline = false
        local inverse = false
        local text = e.text
        local chunk = ""
        local fg = nil
        local bg = nil
        local starttag = ""
        local endtag = ""
        local numbers={}

        while text ~= "" do
            numbers = {}
            -- local s1, e1, c1, d1 = string.find(text, "\x1b%[(.-)([@-~])")
            local s1, e1, c1, d1 = string.find(text, "\u{a35f}\u{2983}(.-)([@-~])")
            if s1 then
                if d1 == "m" then
                    for i in string.gmatch(c1, "([^;]*)") do
                        table.insert(numbers, tonumber(i))
                    end
                else
                    quarto.log.warning("Unsupported ANSI sequence ESC["..c1..d1.." ignored\n" ) 
                end
                chunk, text = text:sub(1, s1-1), text:sub(e1+1)
            else
                chunk, text = text, ""
            end

            if chunk ~= "" then
                if bold and type(fg)=="number" and fg<8 then
                    starttag, endtag = converter(fg+8, bg, bold, underline, inverse)
                else
                    starttag, endtag = converter(fg, bg, bold, underline, inverse)
                end    
                out = out .. starttag .. chunk .. endtag
            end

            while next(numbers) ~= nil do
                local n = table.remove(numbers, 1)
                if n == 0 then
                    fg = nil
                    bg = nil
                    bold = false
                    inverse = false
                    underline = false
                elseif n == 1 then
                    bold = true
                elseif n == 4 then
                    underline = true
                elseif n == 5 then
                    bold = true -- 'blinking'
                elseif n == 7 then
                    inverse = true
                elseif n == 21 or n == 22 then
                    bold = false
                elseif n == 24 then
                    underline = false
                elseif n == 27 then
                    inverse = false
                elseif n >= 30 and n <= 37 then
                    fg = n - 30
                elseif n == 38 then
                    fg = get_extended_color(numbers)
                elseif n == 39 then
                    fg = nil
                elseif n >= 40 and n <= 47 then
                    bg = n - 40
                elseif n == 48 then
                    bg = get_extended_color(numbers)
                elseif n == 49  then
                    bg = nil
                elseif n >= 90 and n <= 97 then
                    fg = n + 8 - 90
                elseif n >= 100 and n <= 107 then
                    bg = n + 8 - 100
                else
                    quarto.log.warning(string.format("ESC sequence with unknown code %d before:\n",n))
                    quarto.log.warning(chunk.."\n")
                end
            end
        end
    else
        out = e.text
    end
    if fmt == 'html' then
        return pandoc.RawBlock(fmt,
            '<pre class="' .. codeclass ..'"><code class="' .. codeclass .. ' ansi">'..out..'</code></pre>')
    end
    if fmt == 'latex' then
        return pandoc.RawBlock(fmt, [[\vspace{-\parskip}\begin{ShadedLight}]].."\n"..[[\begin{]]..texenv.."}\n"..out.."\n"..[[\end{]].. texenv .. "}\n"..[[\end{ShadedLight}]])
    end

end

-- if div has class 'cell-output-stderr', give CodeBlocks in this div the class 'julia-stderr'
local function divStderr(e)
    if e.classes:includes("cell-output-stderr") then
        local c = e.content
        for i,el in pairs(c) do
            if el.t == 'CodeBlock' then
                el.classes:insert("julia-stderr")
            end
        end
        return e
    end
end

-- repair julia ? output
local function divCodeBlockNoHeader1(e)
    if not e.classes:includes("cell-output") then
        return
    end
    local c = e.content
    for i, el in pairs(c) do
        if el.t == 'Header' then
            el.level = 6
            -- elneu = pandoc.Para(el.content)
            -- c[i] = elneu
        end
        if el.t == 'CodeBlock' then
            if el.classes:includes("jldoctest") then
                x,i = el.classes:find("jldoctest")
                el.classes:remove(i)
            end
        end
    end
    return e
end

-- test if two divs should be merged
local function testmerge(d1, d2)
    return d1 and d1.t == "Div"  and d1.classes:includes("cell-output") and #d1.content == 1
        and  d2 and d2.t == "Div"  and d2.classes:includes("cell-output") and #d2.content == 1
        and  d1.content[1].t == "CodeBlock" and not d1.classes:includes("cell-output-stderr")
        and  d2.content[1].t == "CodeBlock" and not d2.classes:includes("cell-output-stderr")
end

-- merge (div (codecell (text1)), div (codecell(text2))) to div(codecell(text1+text2))
local function blockMerge(es)
    local nl = ""
    for i = #es-1, 1, -1 do
        if testmerge(es[i], es[i+1]) then
            str1 = es[i].content[1].text
            str2 = es[i+1].content[1].text
            nl = "\n"
            if es[i].classes:includes("cell-output-stdout") and  es[i+1].classes:includes("cell-output-stdout") then
                if str1:sub(-1) == "\n" then
                    nl = ""
                end
                if str2:sub(1, 1) == "\n" then
                    nl = ""
                end
            end
            es[i].content[1].text = str1 .. nl .. str2
            es:remove(i+1)
        end
    end
    return es
end

local function metaAdd(meta)
    --for key, val in pairs(PANDOC_READER_OPTIONS) do
    --    quarto.log.warning(key, val)    
    --end
    quarto.doc.addHtmlDependency({name='ansicolors',
        stylesheets = {'resources/css/ansicolor.css'}})
    quarto.doc.addHtmlDependency({name='juliamonofont',
        stylesheets = {'resources/css/juliamono.css'}})
    if quarto.doc.isFormat('latex') then
        quarto.doc.include_file("in-header", "resources/juliainc.tex")
    end
end

return {
    {Div = divStderr},
    {Div = divCodeBlockNoHeader1},
    {Blocks = blockMerge},
    {CodeBlock = codeBlockTrans},
    {Meta = metaAdd}
}
