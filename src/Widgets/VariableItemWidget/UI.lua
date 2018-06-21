
local partsWithId = {}
local awaitRef = {}

local Theme = shared.ThemeSettings:GetSettings();

local root = {
	ID = 0;
	Type = "ImageButton";
	Properties = {
		Name = "Item";
		Size = UDim2.new(1,0,0,20);
		BorderColor3 = Theme.BorderColor3;
		BackgroundColor3 = Theme.BackgroundColor3;
		BorderSizePixel = 0;
		AutoButtonColor = false;
	};
	Children = {
		{
			ID = 1;
			Type = "TextLabel";
			Properties = {
				Visible = false;
				FontSize = Enum.FontSize.Size14;
				TextColor3 = Theme.TextColor3;
				Text = "function";
				TextXAlignment = Enum.TextXAlignment.Left;
				Font = Enum.Font.SourceSans;
				Name = "ItemType";
				Position = UDim2.new(0,25,0,0);
				BackgroundTransparency = 1;
				Size = UDim2.new(0.5,0,0,20);
				TextSize = 14;
				BackgroundColor3 = Theme.BackgroundColor3;
			};
			Children = {};
		};
		{
			ID = 2;
			Type = "ImageLabel";
			Properties = {
				Image = "rbxassetid://656467823";
				Name = "Icon";
				Position = UDim2.new(0,18,0,1);
				BackgroundTransparency = 1;
				Size = UDim2.new(0,18,0,18);
				BackgroundColor3 = Theme.BackgroundColor3;
			};
			Children = {};
		};
		{
			ID = 3;
			Type = "TextLabel";
			Properties = {
				FontSize = Enum.FontSize.Size14;
				TextColor3 = Theme.TextColor3;
				Text = "testFunction";
				TextXAlignment = Enum.TextXAlignment.Left;
				Font = Enum.Font.SourceSans;
				Name = "ItemName";
				Position = UDim2.new(0,40,0,0);
				BackgroundTransparency = 1;
				Size = UDim2.new(0.5,0,0,20);
				TextSize = 14;
				BackgroundColor3 = Theme.BackgroundColor3;
			};
			Children = {};
		};
		{
			ID = 4;
			Type = "Frame";
			Properties = {
				Visible = false;
				Name = "Deprecated";
				Position = UDim2.new(0,8,0,10);
				BorderColor3 = Color3.new(1,0,0);
				Size = UDim2.new(0,10,0,0);
				BackgroundColor3 = Color3.new(1,1,1);
			};
			Children = {};
		};
	};
};

local function Scan(item, parent)
	local obj = Instance.new(item.Type)
	if (item.ID) then
		local awaiting = awaitRef[item.ID]
		if (awaiting) then
			awaiting[1][awaiting[2]] = obj
			awaitRef[item.ID] = nil
		else
			partsWithId[item.ID] = obj
		end
	end
	for p,v in pairs(item.Properties) do
		if (type(v) == "string") then
			local id = tonumber(v:match("^_R:(%w+)_$"))
			if (id) then
				if (partsWithId[id]) then
					v = partsWithId[id]
				else
					awaitRef[id] = {obj, p}
					v = nil
				end
			end
		end
		obj[p] = v
	end
	for _,c in pairs(item.Children) do
		Scan(c, obj)
	end
	obj.Parent = parent
	return obj
end

return function() return Scan(root, nil) end