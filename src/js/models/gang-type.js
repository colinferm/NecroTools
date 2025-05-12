Necro.Models.GangType = Backbone.Model.extend({
	urlRoot:     "/api/gang-type",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"type_name": "",
		"house_gang": true
	}
});

Necro.Collections.GangTypes = Backbone.Collection.extend({
	model: Necro.Models.GangType,
	url:   '/api/gang-types',
	
	parse: function(resp) {
		console.log(resp);
		this.add(resp);
		return resp;
	}
});
