-- Gui2Lua Implemented in lua

-- Set Instance at the bottom to the instance you wanna dump
-- V1.2.0

local CollectionService = game:GetService("CollectionService")

local INCLUDE_ATTRIBUTES = true
local INCLUDE_TAGS = true
local INCLUDE_PIVOT = true
local SKIP_DEFAULT_VALUES = true
local ALWAYS_WRITE_CLASS_PROPERTIES = {
	ImageButton = true,
	ImageLabel = true,
	TextBox = true,
	TextButton = true,
	TextLabel = true,
	UIGradient = true,
	UIStroke = true,
}

-- Add custom/hidden property names here if your environment can read them
-- ExtraProperties.Frame = { "NewProperty" }
-- ExtraProperties["*"] = { "Property" }
local ExtraProperties = {}

local PropertyGroups = {
	Instance = { "Name", "Archivable", "SourceAssetId" },
	LayerCollector = { "Enabled", "ResetOnSpawn", "ZIndexBehavior" },
	ScreenGui = {
		"DisplayOrder", "IgnoreGuiInset", "OnTopOfCoreBlur", "SafeAreaCompatibility",
		"ScreenInsets", "ClipToDeviceSafeArea", "SelectionBehaviorDown", "SelectionBehaviorLeft",
		"SelectionBehaviorRight", "SelectionBehaviorUp", "SelectionGroup",
	},
	GuiBase2d = { "AutoLocalize", "RootLocalizationTable", "SelectionImageObject" },
	GuiObject = {
		"Active", "AnchorPoint", "AutomaticSize", "BackgroundColor3", "BackgroundTransparency",
		"BorderColor3", "BorderMode", "BorderSizePixel", "ClipsDescendants", "Draggable",
		"Interactable", "LayoutOrder", "NextSelectionDown", "NextSelectionLeft",
		"NextSelectionRight", "NextSelectionUp", "Position", "Rotation", "Selectable",
		"SelectionOrder", "Size", "SizeConstraint", "Style", "Transparency", "Visible", "ZIndex",
	},
	Frame = {},
	CanvasGroup = { "GroupColor3", "GroupTransparency" },
	ScrollingFrame = {
		"AutomaticCanvasSize", "BottomImage", "CanvasPosition", "CanvasSize", "ElasticBehavior",
		"HorizontalScrollBarInset", "MidImage", "ScrollBarImageColor3", "ScrollBarImageTransparency",
		"ScrollBarThickness", "ScrollingDirection", "ScrollingEnabled", "TopImage",
		"VerticalScrollBarInset", "VerticalScrollBarPosition",
	},
	TextLabel = {
		"ContentText", "Font", "FontFace", "LineHeight", "MaxVisibleGraphemes", "OpenTypeFeatures",
		"RichText", "Text", "TextBounds", "TextColor3", "TextDirection", "TextFits", "TextScaled",
		"TextSize", "TextStrokeColor3", "TextStrokeTransparency", "TextTransparency", "TextTruncate",
		"TextWrapped", "TextXAlignment", "TextYAlignment",
	},
	TextButton = {
		"AutoButtonColor", "ContentText", "Font", "FontFace", "LineHeight", "MaxVisibleGraphemes",
		"Modal", "OpenTypeFeatures", "RichText", "Selected", "Text", "TextBounds", "TextColor3",
		"TextDirection", "TextFits", "TextScaled", "TextSize", "TextStrokeColor3",
		"TextStrokeTransparency", "TextTransparency", "TextTruncate", "TextWrapped",
		"TextXAlignment", "TextYAlignment",
	},
	TextBox = {
		"ClearTextOnFocus", "ContentText", "CursorPosition", "Font", "FontFace", "LineHeight",
		"ManualFocusRelease", "MaxVisibleGraphemes", "MultiLine", "OpenTypeFeatures", "PlaceholderColor3",
		"PlaceholderText", "RichText", "SelectionStart", "ShowNativeInput", "Text", "TextBounds",
		"TextColor3", "TextDirection", "TextEditable", "TextFits", "TextScaled", "TextSize",
		"TextStrokeColor3", "TextStrokeTransparency", "TextTransparency", "TextTruncate", "TextWrapped",
		"TextXAlignment", "TextYAlignment",
	},
	ImageLabel = {
		"ContentImageSize", "Image", "ImageColor3", "ImageRectOffset", "ImageRectSize",
		"ImageTransparency", "IsLoaded", "ResampleMode", "ScaleType", "SliceCenter",
		"SliceScale", "TileSize",
	},
	ImageButton = {
		"AutoButtonColor", "ContentImageSize", "HoverImage", "Image", "ImageColor3",
		"ImageRectOffset", "ImageRectSize", "ImageTransparency", "IsLoaded", "Modal",
		"PressedImage", "ResampleMode", "ScaleType", "Selected", "SliceCenter", "SliceScale", "TileSize",
	},
	VideoFrame = { "IsLoaded", "Looped", "Playing", "Resolution", "TimeLength", "TimePosition", "Video", "Volume" },
	ViewportFrame = { "Ambient", "CurrentCamera", "ImageColor3", "ImageTransparency", "LightColor", "LightDirection" },
	UIAspectRatioConstraint = { "AspectRatio", "AspectType", "DominantAxis" },
	UICorner = { "CornerRadius" },
	UIGradient = { "Color", "Enabled", "Offset", "Rotation", "Transparency" },
	UIGridLayout = {
		"AbsoluteCellCount", "AbsoluteCellSize", "CellPadding", "CellSize", "FillDirection",
		"FillDirectionMaxCells", "HorizontalAlignment", "SortOrder", "StartCorner", "VerticalAlignment",
	},
	UIListLayout = { "FillDirection", "HorizontalAlignment", "Padding", "SortOrder", "VerticalAlignment", "Wraps" },
	UIPadding = { "PaddingBottom", "PaddingLeft", "PaddingRight", "PaddingTop" },
	UIPageLayout = {
		"Animated", "Circular", "EasingDirection", "EasingStyle", "GamepadInputEnabled",
		"Padding", "ScrollWheelInputEnabled", "SortOrder", "TouchInputEnabled", "TweenTime",
	},
	UIScale = { "Scale" },
	UISizeConstraint = { "MaxSize", "MinSize" },
	UIStroke = { "ApplyStrokeMode", "BorderOffset", "Color", "Enabled", "LineJoinMode", "StrokeSizingMode", "Thickness", "Transparency" },
	UITextSizeConstraint = { "MaxTextSize", "MinTextSize" },
	UIFlexItem = { "FlexMode", "GrowRatio", "ItemLineAlignment", "ShrinkRatio" },
	Folder = {},
	BasePart = {
		"Anchored", "AssemblyAngularVelocity", "AssemblyLinearVelocity", "BackSurface", "BottomSurface",
		"BrickColor", "CFrame", "CanCollide", "CanQuery", "CanTouch", "CastShadow", "CollisionGroup",
		"Color", "CustomPhysicalProperties", "FrontSurface", "LeftSurface", "LocalTransparencyModifier",
		"Locked", "Massless", "Material", "MaterialVariant", "Orientation", "PivotOffset", "Position",
		"Reflectance", "RightSurface", "RootPriority", "Rotation", "Size", "TopSurface", "Transparency",
	},
	Model = { "LevelOfDetail", "ModelStreamingMode", "PrimaryPart", "WorldPivot" },
	Camera = { "CFrame", "CameraType", "DiagonalFieldOfView", "FieldOfView", "FieldOfViewMode", "Focus", "HeadLocked", "HeadScale" },
}

local ClassGroups = {
	ScreenGui = { "Instance", "LayerCollector", "ScreenGui" },
	BillboardGui = { "Instance", "LayerCollector" },
	SurfaceGui = { "Instance", "LayerCollector" },
	Frame = { "Instance", "GuiBase2d", "GuiObject", "Frame" },
	CanvasGroup = { "Instance", "GuiBase2d", "GuiObject", "Frame", "CanvasGroup" },
	ScrollingFrame = { "Instance", "GuiBase2d", "GuiObject", "Frame", "ScrollingFrame" },
	TextLabel = { "Instance", "GuiBase2d", "GuiObject", "TextLabel" },
	TextButton = { "Instance", "GuiBase2d", "GuiObject", "TextButton" },
	TextBox = { "Instance", "GuiBase2d", "GuiObject", "TextBox" },
	ImageLabel = { "Instance", "GuiBase2d", "GuiObject", "ImageLabel" },
	ImageButton = { "Instance", "GuiBase2d", "GuiObject", "ImageButton" },
	VideoFrame = { "Instance", "GuiBase2d", "GuiObject", "VideoFrame" },
	ViewportFrame = { "Instance", "GuiBase2d", "GuiObject", "Frame", "ViewportFrame" },
	UIAspectRatioConstraint = { "Instance", "UIAspectRatioConstraint" },
	UICorner = { "Instance", "UICorner" },
	UIGradient = { "Instance", "UIGradient" },
	UIGridLayout = { "Instance", "UIGridLayout" },
	UIListLayout = { "Instance", "UIListLayout" },
	UIPadding = { "Instance", "UIPadding" },
	UIPageLayout = { "Instance", "UIPageLayout" },
	UIScale = { "Instance", "UIScale" },
	UISizeConstraint = { "Instance", "UISizeConstraint" },
	UIStroke = { "Instance", "UIStroke" },
	UITextSizeConstraint = { "Instance", "UITextSizeConstraint" },
	UIFlexItem = { "Instance", "UIFlexItem" },
	Folder = { "Instance", "Folder" },
	Part = { "Instance", "BasePart" },
	MeshPart = { "Instance", "BasePart" },
	UnionOperation = { "Instance", "BasePart" },
	Model = { "Instance", "Model" },
	Camera = { "Instance", "Camera" },
}

local DefaultCache = {}

local function AddUnique(list, seen, value)
	if not seen[value] then
		seen[value] = true
		table.insert(list, value)
	end
end

local function GetPropertyNames(object)
	local names = {}
	local seen = {}

	for _, groupName in ipairs(ClassGroups[object.ClassName] or { "Instance" }) do
		for _, propName in ipairs(PropertyGroups[groupName] or {}) do
			AddUnique(names, seen, propName)
		end
	end

	for _, propName in ipairs(ExtraProperties[object.ClassName] or {}) do
		AddUnique(names, seen, propName)
	end

	for _, propName in ipairs(ExtraProperties["*"] or {}) do
		AddUnique(names, seen, propName)
	end

	if typeof(getproperties) == "function" then
		local ok, props = pcall(getproperties, object)
		if ok and type(props) == "table" then
			for key in pairs(props) do
				if type(key) == "string" then
					AddUnique(names, seen, key)
				end
			end
		end
	end

	return names
end

local function Number(value)
	if value ~= value then
		return "0/0"
	elseif value == math.huge then
		return "math.huge"
	elseif value == -math.huge then
		return "-math.huge"
	end

	return string.format("%.17g", value)
end

local function Serialize(value, refs)
	local valueType = typeof(value)

	if value == nil then
		return "nil"
	elseif valueType == "string" then
		return string.format("%q", value)
	elseif valueType == "number" then
		return Number(value)
	elseif valueType == "boolean" then
		return tostring(value)
	elseif valueType == "EnumItem" then
		return tostring(value)
	elseif valueType == "Vector2" then
		return ("Vector2.new(%s, %s)"):format(Number(value.X), Number(value.Y))
	elseif valueType == "Vector2int16" then
		return ("Vector2int16.new(%d, %d)"):format(value.X, value.Y)
	elseif valueType == "Vector3" then
		return ("Vector3.new(%s, %s, %s)"):format(Number(value.X), Number(value.Y), Number(value.Z))
	elseif valueType == "Vector3int16" then
		return ("Vector3int16.new(%d, %d, %d)"):format(value.X, value.Y, value.Z)
	elseif valueType == "UDim" then
		return ("UDim.new(%s, %d)"):format(Number(value.Scale), value.Offset)
	elseif valueType == "UDim2" then
		return ("UDim2.new(%s, %d, %s, %d)"):format(Number(value.X.Scale), value.X.Offset, Number(value.Y.Scale), value.Y.Offset)
	elseif valueType == "Color3" then
		return ("Color3.new(%s, %s, %s)"):format(Number(value.R), Number(value.G), Number(value.B))
	elseif valueType == "BrickColor" then
		return ("BrickColor.new(%q)"):format(value.Name)
	elseif valueType == "Rect" then
		return ("Rect.new(%s, %s, %s, %s)"):format(Number(value.Min.X), Number(value.Min.Y), Number(value.Max.X), Number(value.Max.Y))
	elseif valueType == "CFrame" then
		local components = {}
		for _, component in ipairs({ value:GetComponents() }) do
			table.insert(components, Number(component))
		end
		return ("CFrame.new(%s)"):format(table.concat(components, ", "))
	elseif valueType == "NumberRange" then
		return ("NumberRange.new(%s, %s)"):format(Number(value.Min), Number(value.Max))
	elseif valueType == "NumberSequence" then
		local keypoints = {}
		for _, keypoint in ipairs(value.Keypoints) do
			table.insert(keypoints, ("NumberSequenceKeypoint.new(%s, %s, %s)"):format(Number(keypoint.Time), Number(keypoint.Value), Number(keypoint.Envelope)))
		end
		return ("NumberSequence.new({ %s })"):format(table.concat(keypoints, ", "))
	elseif valueType == "ColorSequence" then
		local keypoints = {}
		for _, keypoint in ipairs(value.Keypoints) do
			table.insert(keypoints, ("ColorSequenceKeypoint.new(%s, %s)"):format(Number(keypoint.Time), Serialize(keypoint.Value, refs)))
		end
		return ("ColorSequence.new({ %s })"):format(table.concat(keypoints, ", "))
	elseif valueType == "Font" or valueType == "FontFace" then
		local ok, family, weight, style = pcall(function()
			return value.Family, value.Weight, value.Style
		end)
		if ok then
			return ("Font.new(%q, %s, %s)"):format(family, tostring(weight), tostring(style))
		end
	elseif valueType == "PhysicalProperties" then
		return ("PhysicalProperties.new(%s, %s, %s, %s, %s)"):format(
			Number(value.Density),
			Number(value.Friction),
			Number(value.Elasticity),
			Number(value.FrictionWeight),
			Number(value.ElasticityWeight)
		)
	elseif valueType == "Instance" then
		return refs[value] or "nil"
	end

	return nil
end

local function ReadProperty(object, propertyName)
	if typeof(gethiddenproperty) == "function" then
		local ok, value = pcall(gethiddenproperty, object, propertyName)
		if ok then
			return true, value
		end
	end

	local ok, value = pcall(function()
		return object[propertyName]
	end)
	return ok, value
end

local function Skip(object, propertyName, value)
	if not SKIP_DEFAULT_VALUES then
		return false
	end

	DefaultCache[object.ClassName] = DefaultCache[object.ClassName] or {}
	local classCache = DefaultCache[object.ClassName]

	if classCache[propertyName] == nil then
		local ok, probe = pcall(Instance.new, object.ClassName)
		if not ok then
			classCache[propertyName] = false
			return false
		end

		local readOk, defaultValue = pcall(function()
			return probe[propertyName]
		end)
		probe:Destroy()
		classCache[propertyName] = readOk and defaultValue or false
	end

	local defaultValue = classCache[propertyName]
	return defaultValue ~= false and value == defaultValue
end

local function Dump(root, rootPE)
	assert(typeof(root) == "Instance", "dump expects an Instance")

	local objects = { root }
	for _, descendant in ipairs(root:GetDescendants()) do
		table.insert(objects, descendant)
	end

	local refs = {}
	for index, object in ipairs(objects) do
		refs[object] = ("objects[%d]"):format(index)
	end

	local lines = {
		"-- Generated by GuiToLua",
		"local CollectionService = game:GetService(\"CollectionService\")",
		"",
		"local function SetProperty(object, property, value)",
		"\tlocal ok = pcall(function() object[property] = value end)",
		"\tif not ok and typeof(sethiddenproperty) == \"function\" then",
		"\t\tpcall(sethiddenproperty, object, property, value)",
		"\tend",
		"end",
		"",
		"local objects = {}",
		"",
	}

	for index, object in ipairs(objects) do
		local ref = refs[object]
		table.insert(lines, ("%s = Instance.new(%q)"):format(ref, object.ClassName))

		if object ~= root then
			table.insert(lines, ("%s.Parent = %s"):format(ref, refs[object.Parent] or "nil"))
		end

		for _, PropName in ipairs(GetPropertyNames(object)) do
			if PropName ~= "Parent" then
				local ok, value = ReadProperty(object, PropName)
				local serialized = ok and Serialize(value, refs)
				if serialized and (ALWAYS_WRITE_CLASS_PROPERTIES[object.ClassName] or not Skip(object, PropName, value)) then
					table.insert(lines, ("SetProperty(%s, %q, %s)"):format(ref, PropName, serialized))
				end
			end
		end

		if INCLUDE_ATTRIBUTES then
			for name, value in pairs(object:GetAttributes()) do
				local serialized = Serialize(value, refs)
				if serialized then
					table.insert(lines, ("%s:SetAttribute(%q, %s)"):format(ref, name, serialized))
				end
			end
		end

		if INCLUDE_TAGS then
			for _, tag in ipairs(CollectionService:GetTags(object)) do
				table.insert(lines, ("CollectionService:AddTag(%s, %q)"):format(ref, tag))
			end
		end

		if INCLUDE_PIVOT and object:IsA("PVInstance") then
			local ok, pivot = pcall(function()
				return object:GetPivot()
			end)
			if ok then
				table.insert(lines, ("%s:PivotTo(%s)"):format(ref, Serialize(pivot, refs)))
			end
		end

		if index < #objects then
			table.insert(lines, "")
		end
	end

	table.insert(lines, "")
	if rootPE and rootPE ~= "" then
		table.insert(lines, ("%s.Parent = %s"):format(refs[root], rootPE))
	end
	table.insert(lines, ("return %s"):format(refs[root]))

	return table.concat(lines, "\n")
end

-- Put your instance here
local Instance = nil

setclipboard(Dump(Instance, [[--Dump output's here]]))
