Necro.Models.Gang = Backbone.Model.extend({
	urlRoot:     "/api/gang",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"gang_name": "",
		"outlaw": false,
		"num_fighters": 0,
		"fighters": Necro.Models.FighterCollection,
		"stash": Necro.Models.WeaponCollection
	},

	getValue: function() {
		var total = 0;
		var fighters = this.get("fighters");
		_.each(fighters.models, function(fighter){
			total += weapon.getValue();
		});
		var weapons = this.get("weapons");
		_.each(weapons.models, function(weapon){
			total += weapon.get("weapon_value");
		});
		return total;
	},

	parse: function(response) {
		if (response.created) response.created = new Date(response.created);
		if (response.last_mod) response.last_mod = new Date(response.last_mod);
		var fighters = [];
		if (response.fighters) {
			_.each(response.fighters, function(fighter) {
				fighters.push(new Necro.Models.Fighter(fighter));
			});
			response.fighters = fighters;
		}
		console.log(response);
		return response;
	}
});
Necro.Models.GangCollection = Backbone.Collection.extend({
	model: Necro.Models.Gang,
	url:   '/api/gangs',
	parse: function(resp) {
		console.log(resp);
		this.add(resp);
		return resp;
	}
});