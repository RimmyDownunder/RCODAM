class RCODAM_CreateExclusionZone: Module_F
{
	scope = 2;
	displayName = "Create Exclusion Zone";
	category = "RCODAM_modules";
	function = "RCODAM_fnc_RCODAMcreateExclusionZone";
	icon = "\a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
	functionPriority = 2;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;

	class Attributes: AttributesBase
	{
		class RCODAM_side: Combo
		{
			property = "RCODAM_side";
			displayName="Side to Exclude";
			tooltip=$STR_RCODAM_Modules_side_tooltip;
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
				class GUER
				{
					name="Independent";
					value="RESISTANCE";
				};
			};
		};
		
		class RCODAM_radiusX: Edit
		{
			property = "RCODAM_radiusX";
			displayName="Radius X";
			tooltip=$STR_RCODAM_Modules_radiusX_tooltip;
			typeName="NUMBER";
			defaultValue = 250;
		};
		
		class RCODAM_radiusY: Edit
		{
			property = "RCODAM_radiusY";
			displayName="Radius Y";
			tooltip=$STR_RCODAM_Modules_radiusY_tooltip;
			typeName="NUMBER";
			defaultValue = 250;
		};
		
		class RCODAM_debug: CheckBox
		{
			property = "RCODAM_debug";
			displayName="Debug Mode";
			tooltip=$STR_RCODAM_Modules_debug_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] =
		{
			$STR_RCODAM_Modules_CreateExclusionZone_description
		};
	};
};