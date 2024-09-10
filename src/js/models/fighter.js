Necro.Models.Fighter = Backbone.Model.extend({
	urlRoot:     "/api/fighter",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"gang": Necro.Models.Gang,
		"fighter_name": "",
		"movement": "",
		"weapon_skill": "",
		"balistic_kill": "",
		"strength": "",
		"toughness": "",
		"wounds": "1",
		"initiative": "",
		"attacks": "",
		"leadership": "",
		"cool": "",
		"willpower": "",
		"intelligence": "",
		"is_vehicle": false,
		"is_convalescence": false,
		"experience": 0,
		"base_value": 0,
		"weapons": Necro.Models.WeaponCollection,
		"gear": Necro.Models.GearCollection
	},

	getValue: function() {
		var val = this.get("base_value");
		var weapons = this.get("weapons");
		_.each(weapons.models, function(weapon){
			val += weapon.getValue();
		});

		var gear = this.get("gear");
		_.each(gear.models, function(gear){
			val += gear.get("base_value");
		});
		return val;
	}
});
Necro.Models.FighterCollection = Backbone.Collection.extend({
	model: Necro.Models.Fighter,
	url:   '/api/fighters'
});

Necro.Models.Gear = Backbone.Model.extend({
	urlRoot:     "/api/gear",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"gear_name": "",
		"base_value": 0
	}
});
Necro.Models.GearCollection = Backbone.Collection.extend({
	model: Necro.Models.Gear,
	url:   '/api/gear'
});