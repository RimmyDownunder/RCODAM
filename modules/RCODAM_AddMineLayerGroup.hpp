class RCODAM_AddMineLayerGroup: Module_F
{
	scope = 2;
	displayName = "Add Mine Layer Group";
	category = "RCODAM_modules";
	function = "RCODAM_fnc_RCODAMmineGroupAssigner";
	icon = "\a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
	functionPriority = 2;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;

	class Attributes: AttributesBase
	{
		
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] =
		{
			$STR_RCODAM_Modules_AddMineLayerGroup_description
		};
	};
};