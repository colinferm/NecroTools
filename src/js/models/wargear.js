Necro.Models.Wargear = Backbone.Model.extend({
	urlRoot: "/api/gear",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"weapon_name": null,
		"category_name": null,
		"weapon_category_id": 0,
		"weapon_value": 0,
		"rarity": "C"
	},
});

Necro.Collections.Wargear = Backbone.Collection.extend({
	model: Necro.Models.Wargear,
	url:   "/api/gear",
	parse: function(resp) {
		this.add(resp);
		return resp;
	}
});