Necro.Models.Lookup = Backbone.Model.extend({
	idAttribute: "id",
	url: function() {
		if (this.id && this.id > 0) {
			return "/api/lookup/" + this.id;
		}
		return "/api/lookup";
	},
	defaults:    {
		"id": null,
		"gang_type_id": null,
		"lookup_value": "",
		"misc_value": "0",
		"lookup_key": "",
		"is_special_attribute": 0,
		"is_gang_related": 0,
		"is_fighter_related": 0,
		"notes": ""
	}
});

Necro.Collections.Lookups = Backbone.Collection.extend({
	model: Necro.Models.Lookup,
	url: '/api/lookups'

});