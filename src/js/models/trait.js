Necro.Models.Trait = Backbone.Model.extend({
	urlRoot:     "/api/trait",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"trait_name": "",
        "trait_value": "0",
        "notes": "",
	}
});

Necro.Collections.Traits = Backbone.Collection.extend({
	model: Necro.Models.Trait,
	url:   '/api/traits',
	
	initialize: function() {
		this.comparator = "trait_name";
	},

	parse: function(resp) {
		console.log(resp);
		this.add(resp);
		return resp;
	}
});