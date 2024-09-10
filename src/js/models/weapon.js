Necro.Models.Weapon = Backbone.Model.extend({
	urlRoot:     "/api/weapon",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"weapon_name": "",
		"weapon_value": 0,
		"characteristics":  Necro.Models.WeaponCharacteristicCollection
	},

	getValue: function() {
		var baseVal = this.get("weapon_value");
		var characteristics = this.get("characteristic");
		_.each(characteristics.models, function(characteristic) {
			var traits = characteristic.get("traits");
			_.each(traits.models, function(trait) {
				baseVal += trait.get("trait_value");
			});
		});
		return baseVal;
	}
});
Necro.Models.WeaponCollection = Backbone.Collection.extend({
	model: Necro.Models.Weapon,
	url:   '/api/weapons'
});

Necro.Models.WeaponCharacteristic = Backbone.Model.extend({
	urlRoot:     "/api/weapon_characteristic",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"range_short": "",
		"range_long": "",
		"accuracy_short": "",
		"accuracy_long": "",
		"strength": "",
		"armor_penetration": "",
		"damage": 1,
		"ammo_check": 4,
		"traits": Necro.Models.WeaponTraitCollection
	}
});
Necro.Models.WeaponCharacteristicCollection = Backbone.Collection.extend({
	model: Necro.Models.WeaponCharacteristic,
	url:   '/api/weapon_characteristics'
});

Necro.Models.WeaponTrait = Backbone.Model.extend({
	urlRoot:     "/api/weapon_trait",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"trait_value": 0
	}
});
Necro.Models.WeaponTraitCollection = Backbone.Collection.extend({
	model: Necro.Models.WeaponCharacteristic,
	url:   '/api/weapon_traits'
});