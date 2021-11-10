class RCODAM_RestrictObjective: Module_F
{
	scope = 2;
	displayName = "Restrict Group Objectives";
	category = "RCODAM_modules";
	function = "RCODAM_fnc_RCODAMmineGroupTaskRestrict";
	icon = "\a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
	functionPriority = 2;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;

	class Attributes: AttributesBase
	{
		
		class RCODAM_defenceObjectiveChoice: CheckBox
		{
			property = "RCODAM_defenceObjectiveChoice";
			displayName="Defence Objectives";
			tooltip=$STR_RCODAM_Modules_RestrictTooltip_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class RCODAM_interceptObjectiveChoice: CheckBox
		{
			property = "RCODAM_interceptObjectiveChoice";
			displayName="Intercept Objectives";
			tooltip=$STR_RCODAM_Modules_RestrictTooltip_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class RCODAM_interdictObjectiveChoice: CheckBox
		{
			property = "RCODAM_interdictObjectiveChoice";
			displayName="Interdict Objectives";
			tooltip=$STR_RCODAM_Modules_RestrictTooltip_tooltip;
			typeName="BOOL";
			defaultValue = "False";
		};
		
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] =
		{
			$STR_RCODAM_Modules_RestrictObjective_description
		};
	};
};