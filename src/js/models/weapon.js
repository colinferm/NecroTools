Necro.Models.Weapon = Backbone.Model.extend({
	urlRoot:     "/api/weapon",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"weapon_name": "",
		"weapon_value": 0,
		"category_id": null,
		"characteristics":  Necro.Collections.WeaponCharacteristics
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
	},

	parse: function(response) {
		var characteristics = [];
		if (response.characteristics) {
			_.each(response.characteristics, function(char) {
				characteristics.push(new Necro.Models.WeaponCharacteristic(char));
			});
			response.characteristics = new Necro.Collections.WeaponCharacteristics(characteristics);
		}
		return response;
	}
});
Necro.Collections.Weapons = Backbone.Collection.extend({
	model: Necro.Models.Weapon,
	url:   '/api/weapons'
});

Necro.Models.WeaponCharacteristic = Backbone.Model.extend({
	urlRoot:     "/api/weapon-characteristic",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"ammo_type": null,
		"range_short": "",
		"range_long": "",
		"accuracy_short": "",
		"accuracy_long": "",
		"strength": "",
		"armor_penetration": "",
		"damage": 1,
		"ammo_check": 4,
		"traits": Necro.Collections.WeaponTraits
	},

	parse: function(response) {
		var traits = [];
		if (response.traits) {
			_.each(response.traits, function(trait) {
				traits.push(new Necro.Models.WeaponTrait(trait));
			});
			response.traits = Necro.Collections.WeaponTraits(traits);
		}
		return response;
	}
});

Necro.Collections.WeaponCharacteristics = Backbone.Collection.extend({
	model: Necro.Models.WeaponCharacteristic,
	url:   '/api/weapon-characteristics'
});

Necro.Models.WeaponTrait = Backbone.Model.extend({
	urlRoot:     "/api/trait",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"trait_name": null,
		"trait_value": 0,
		"notes": null
	}
});
Necro.Collections.WeaponTraits = Backbone.Collection.extend({
	model: Necro.Models.WeaponCharacteristic,
	url:   '/api/traits',
});