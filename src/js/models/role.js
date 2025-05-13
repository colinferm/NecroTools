Necro.Models.GangRole = Backbone.Model.extend({
	urlRoot:     "/api/gang",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"gang_name": "",
		"outlaw": false,
		"num_fighters": 0,
		"fighters": null,
		"stash": null,
		"primary_skills": null,
		"secondary_skills": null
	},

	parse: function(resp) {
		var pskills = new Necro.Collections.SkillSets();
		var sskills = new Necro.Collections.SkillSets();

		pskills.roleId = resp.id;
		sskills.roleId = resp.id;

		_.each(resp.primary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			pskills.add(skillSet);
		}, this);

		_.each(resp.secondary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			sskills.add(skillSet);
		}, this);

		resp.primary_skills = pskills;
		resp.secondary_skills = sskills;
		return resp;
	},
});

Necro.Collections.GangRoles = Backbone.Collection.extend({
	model: Necro.Models.GangRole,
	gangId: 0,

	initialize: function(options) {
		//if (options.gangId) this.gangId = options.gangId;
	},

	url: function() {
		return '/api/gang-types/' + this.gangId + '/roles';
	}

});