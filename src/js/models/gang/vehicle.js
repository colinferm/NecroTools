Necro.Models.Vehicle = Necro.Models.Fighter.extend({
	urlRoot:     "/api/fighter",
	idAttribute: "id",
	defaults:    {
		"toughness_side": 4,
		"toughness_rear": 3,
		"handling": 3,
		"save_roll": 0,
		"is_vehicle": true,
	}
});