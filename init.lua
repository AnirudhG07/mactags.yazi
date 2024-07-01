local Color_mapping = {
	r = "red",
	b = "blue",
	g = "green",
	y = "yellow",
	o = "orange",
	p = "purple",
	a = "grey", -- because grey sounds like a
	h = "home",
	i = "important",
	w = "work",
}
local Shell_value = os.getenv("SHELL"):match(".*/(.*)")

local function fail(s, ...)
	ya.notify({ title = "Mactags", content = string.format(s, ...), timeout = 5, level = "error" })
end

local function error_msg_display(child, err)
	if not child then
		return fail("Spawn `mactag` failed with error code %s. Do you have `tag` installed?", err)
	end

	local output, err = child:wait_with_output()
	if not output then
		return fail("Cannot read `mactag` output, error code %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("`mactag` exited with error code %s", output.status.code)
    else
        return true
    end
end

local function colset_notify(str)
	ya.notify({
		title = "Mactags",
		content = str,
		timeout = 3,
		level = "info",
	})
end

local auto_generate_tag = function()
	-- if input_tag is empty,auto find a col to bind from begin Tag_colors
	local auto_assign_tag = "none" -- default assign tag is NONE
	colset_notify("You have not assigned any tag.")

	return auto_assign_tag
end

local assign_col = function(input_col)
	-- input of this function is format {"g", "w", "i"}
	-- Function to map input_col to single-character cols
	local function map_cols(input_col)
		local mapped_cols = {}
		for _, color in ipairs(input_col) do
			local lower_color = color:lower()
			local col = Color_mapping[lower_color] or lower_color
			if col then
				table.insert(mapped_cols, col)
			else
				colset_notify("assign fail, invalid color: " .. color)
				return nil
			end
		end
		return mapped_cols
	end

	local mapped_cols = map_cols(input_col)
	-- Map the input_col to single-character cols
	if not mapped_cols then
		return nil
	end

	local unique_cols = {}
	local unique_cols_set = {}

	for _, col in ipairs(mapped_cols) do
		if not unique_cols_set[col] then
			table.insert(unique_cols, col)
			unique_cols_set[col] = true
		end
	end

    -- Convert the mapped cols to a space-separated string
    local col_string = table.concat(mapped_cols, " ")

    -- Check if the col_string is too long
    local i = 0
    for col in col_string:gmatch("%S+") do
        i = i + 1
        if i > 10 then -- since max 10 tags are possible
            colset_notify("Assign fail, col too long. Assigning all the tags.")
            return "red green blue yellow orange purple grey home important work"
        end
    end
    return col_string
end

local function get_tags()
	local col_set, event = ya.input({
		realtime = false,
		title = "set tag color(s) as - 'r g i w'",
		position = { "top-right", y = 3, w = 40 },
	})
	if event == 1 and col_set ~= "" then
		-- Split the input string into a table of cols
        local cols = {}
        for col in col_set:gmatch("%S+") do
			table.insert(cols, col)
		end
		-- Checking input for errors
		local assigned_cols = assign_col(cols)
		-- assigned_cols is a string "red green blue"
		if assigned_cols == nil then
			return get_tags()
		else
			return assigned_cols
		end

	elseif event == 1 and col_set == "" then
		local generate_col = auto_generate_tag()
		return generate_col
	else
		return nil
	end
end

local state = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local add_remove = function(args, generated_tags, file_path)

	if generated_tags == "none" then
		return
	end
    local cwd = state()
    local flag = ""
    if args == "add" then
        flag = "--add"
    elseif args == "remove" then
        flag = "--remove"
    elseif args == "remove_all" then
        generated_tags = "red green blue yellow orange purple grey home important work"
        flag = "--remove"
    end
	-- Split the input string into individual tags
	local tags = {}
	for tag in generated_tags:gmatch("%S+") do
        tag = Color_mapping[tag] or tag
		table.insert(tags, tag)
	end
	-- Run the command separately for each tag
    for _, tag in ipairs(tags) do
        local cmd_args = "tag " .. flag .. " " .. tag .. " " .. file_path
        local child, err = Command(Shell_value)
		:args({ "-c", cmd_args })
		:cwd(cwd)
		:stdin(Command.INHERIT)
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

        local success = error_msg_display(child, err)
        if not success then
            return false
        end
    end
end

return {
	entry = function(_, args)
		local action = args[1]
		if not action then
			return
		end

        local file_path = "/add/absolute/path" -- yet to implement hovered
        local col = ""
        if action == "add" or action == "remove" then
            local col = get_tags()
            if col == nil then
                return
            end
            add_remove(action, col, file_path)
        elseif action == "remove_all" then
            add_remove(action, col , file_path)
        end
	end
}
