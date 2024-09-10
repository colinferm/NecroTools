Necro.Models.Gang = Backbone.Model.extend({
	urlRoot:     "/api/gang",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"gang_name": "",
		"outlaw": false,
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