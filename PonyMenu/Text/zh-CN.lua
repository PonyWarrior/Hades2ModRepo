local mod = PonyMenu

if not mod.Config.Enabled then return end

mod.AddLocale("zh-CN", {
	PonyMenuCategoryTitle = "小马选单",

	ClearAllBoons = "去除一切祝福",
	ClearAllBoonsDescription = "去除每个祝福。",

	BoonSelectorTitle = "祝福选择器",
	BoonSelectorSpawnButton = "召见祝福",
	BoonSelectorCommonButton = "Common",
	BoonSelectorRareButton = "Rare",
	BoonSelectorEpicButton = "Epic",
	BoonSelectorHeroicButton = "Heroic",

	BoonManagerTitle = "祝福经理",
	BoonManagerSubtitle = "为了换加法(+)和剑法(-)，再点击级运作方式或稀有度运作方式。",
	BoonManagerDescription = "打开祝福经理。让您经理您的祝福。您会去除和升级您的祝福。",
	BoonManagerModeSelection = "请选运作方式",
	BoonManagerLevelMode = "级运作方式",
	BoonManagerRarityMode = "稀有度运作方式",
	BoonManagerDeleteMode = "去除运作方式",
	BoonManagerAllModeOff = "全运作方式 : 关",
	BoonManagerAllModeOn = "全运作方式 ： 开",
	BoonManagerLevelDisplay = "级. ",

	ResourceMenuTitle = "资源选单",
	ResourceMenuDescription = "创造任何数量的资源。",
	ResourceMenuSpawnButton = "创造资源"
})
