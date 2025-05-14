Necro.Models.GangType = Backbone.Model.extend({
	urlRoot:     "/api/gang-type",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"type_name": "",
		"house_gang": true,
		"outlaw": false,
		"gang_description": "",
		"created": "",
		"last_mod": ""
	}
});

Necro.Collections.GangTypes = Backbone.Collection.extend({
	model: Necro.Models.GangType,
	url:   '/api/gang-types',

	parse: function(resp) {
		this.add(resp);
		return resp;
	}
});
