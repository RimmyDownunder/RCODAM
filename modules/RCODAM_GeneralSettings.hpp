class RCODAM_GeneralSettings: Module_F
{
	scope = 2;
	displayName = "DAM General Settings";
	category = "RCODAM_modules";
	function = "RCODAM_fnc_RCODAMsettingsInitialiser";
	icon = "\a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
	functionPriority = 2;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;

	class Attributes: AttributesBase
	{
		class RCODAM_mineSide: Combo
		{
			property = "RCODAM_mineSide";
			displayName="Side of Minelayers";
			tooltip=$STR_RCODAM_Modules_mineSide_description;
			typeName="STRING";
			defaultValue = """WEST""";
			class values
			{
				class WEST
				{
					name="BLUFOR";
					value="WEST";
				};
				class EAST
				{
					name="OPFOR";
					value="EAST";
				};
				class RESISTANCE
				{
					name="Independent";
					value="RESISTANCE";
				};
			};
		};
		
		class RCODAM_updateTimer: Edit
		{
			property = "RCODAM_updateTimer";
			displayName="Scanner Update Timer";
			tooltip=$STR_RCODAM_Modules_updateTimer_tooltip;
			typeName="NUMBER";
			defaultValue = 900;
		};
		
		class RCODAM_mineUpdateTimer: Edit
		{
			property = "RCODAM_mineUpdateTimer";
			displayName="Mine Objective Update Timer";
			tooltip=$STR_RCODAM_Modules_mineUpdateTimer_tooltip;
			typeName="NUMBER";
			defaultValue = 600;
		};
		
		class RCODAM_groupLimitChoice: Edit
		{
			property = "RCODAM_groupLimitChoice";
			displayName="Groups to Make Taskforce";
			tooltip=$STR_RCODAM_Modules_groupLimitChoice_tooltip;
			typeName="NUMBER";
			defaultValue = 4;
		};
		
		class RCODAM_groupSizeLimitChoice: Edit
		{
			property = "RCODAM_groupSizeLimitChoice";
			displayName="Soldiers Nearby to Make Group";
			tooltip=$STR_RCODAM_Modules_groupSizeLimitChoice_tooltip;
			typeName="NUMBER";
			defaultValue = 3;
		};
		
		class RCODAM_friendlyGroupLimitChoice: Edit
		{
			property = "RCODAM_friendlyGroupLimitChoice";
			displayName="Friendly Groups to Make Taskforce";
			tooltip=$STR_RCODAM_Modules_groupLimitChoice_tooltip;
			typeName="NUMBER";
			defaultValue = 6;
		};
		
		class RCODAM_friendlyGroupSizeLimitChoice: Edit
		{
			property = "RCODAM_friendlyGroupSizeLimitChoice";
			displayName="Friendly Soldiers to Make Group";
			tooltip=$STR_RCODAM_Modules_groupSizeLimitChoice_tooltip;
			typeName="NUMBER";
			defaultValue = 4;
		};
		
		class RCODAM_forgetTimer: Edit
		{
			property = "RCODAM_forgetTimer";
			displayName="Forgetting Group Timer";
			tooltip=$STR_RCODAM_Modules_forgetTimer_tooltip;
			typeName="NUMBER";
			defaultValue = 1200;
		};
		
		class RCODAM_runIfEmpty: CheckBox
		{
			property = "RCODAM_runIfEmpty";
			displayName="Scan If Empty";
			tooltip=$STR_RCODAM_Modules_runIfEmpty_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class RCODAM_needTaskForceforIntercept: CheckBox
		{
			property = "RCODAM_needTaskForceforIntercept";
			displayName="Taskforce for Intercept Objectives";
			tooltip=$STR_RCODAM_Modules_needTaskForceforIntercept_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class RCODAM_mineChance: Edit
		{
			property = "RCODAM_mineChance";
			displayName="Mine Chance";
			tooltip=$STR_RCODAM_Modules_mineChance_tooltip;
			typeName="NUMBER";
			defaultValue = 0.9;
		};
		
		class RCODAM_defenceChance: Edit
		{
			property = "RCODAM_defenceChance";
			displayName="Defence Objective Chance";
			tooltip=$STR_RCODAM_Modules_defenceChance_tooltip;
			typeName="NUMBER";
			defaultValue = 0.6;
		};
		
		class RCODAM_interceptChance: Edit
		{
			property = "RCODAM_interceptChance";
			displayName="Intercept Objective Chance";
			tooltip=$STR_RCODAM_Modules_interceptChance_tooltip;
			typeName="NUMBER";
			defaultValue = 0.3;
		};
		
		class RCODAM_interdictChance: Edit
		{
			property = "RCODAM_interdictChance";
			displayName="Interdict Objective Chance";
			tooltip=$STR_RCODAM_Modules_interdictChance_tooltip;
			typeName="NUMBER";
			defaultValue = 0.1;
		};
		
		class RCODAM_roadChance: Edit
		{
			property = "RCODAM_roadChance";
			displayName="Road Preference Chance";
			tooltip=$STR_RCODAM_Modules_roadChance_tooltip;
			typeName="NUMBER";
			defaultValue = 0.8;
		};
		
		class RCODAM_furthestTravel: Edit
		{
			property = "RCODAM_furthestTravel";
			displayName="Distance Limit";
			tooltip=$STR_RCODAM_Modules_furthestTravel_tooltip;
			typeName="NUMBER";
			defaultValue = 5000;
		};
		
		class RCODAM_ATMineList: Edit
		{
			property = "RCODAM_ATMineList";
			displayName="AT Mines";
			tooltip=$STR_RCODAM_Modules_ATMines_tooltip;
			typeName="STRING";
			defaultValue = "[]";
		};
		
		class RCODAM_minimumMineCount: Edit
		{
			property = "RCODAM_minimumMineCount";
			displayName="Minimum Mine Count";
			tooltip=$STR_RCODAM_Modules_minimumMineCount_tooltip;
			typeName="NUMBER";
			defaultValue = 4;
		};
		
		class RCODAM_groupDetector: CheckBox
		{
			property = "RCODAM_groupDetector";
			displayName="Auto Detect Mine Groups";
			tooltip=$STR_RCODAM_Modules_groupDetector_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class RCODAM_debugMode: CheckBox
		{
			property = "RCODAM_debugMode";
			displayName="Debug Mode";
			tooltip=$STR_RCODAM_Modules_debugMode_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] =
		{
			$STR_RCODAM_Modules_GeneralSettings_description
		};
	};
};