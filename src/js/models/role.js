Necro.Models.GangRole = Backbone.Model.extend({
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


});