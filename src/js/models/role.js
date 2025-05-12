Necro.Models.GangRole = Backbone.Model.extend({
	urlRoot:     "/api/gang",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"gang_name": "",
		"outlaw": false,
		"num_fighters": 0,
		"fighters": Necro.Models.FighterCollection,
		"stash": Necro.Models.WeaponCollection,
		"primary_skills": Necro.Collections.SkillSets,
		"secondary_skills": Necro.Collections.SkillSets
	},

	parse: function(resp) {
		this.attributes.primary_skills = new Necro.Collections.SkillSets();
		this.attributes.secondary_skills = new Necro.Collections.SkillSets();

		this.attributes.primary_skills.roleId = resp.id;
		this.attributes.secondary_skills.roleId = resp.id;

		_.each(resp.primary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			this.attributes.primary_skills.add(skillSet);
		}, this);

		_.each(resp.secondary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			this.attributes.secondary_skills.add(skillSet);
		}, this);

		delete resp.primary_skills;
		delete resp.secondary_skills;
		return resp;
	},
});

Necro.Collections.GangRoles = Backbone.Collection.extend({
	model: Necro.Models.GangRole,
	gangId: 0,

	initialize: function(options) {
		if (options.gangId) this.gangId = options.gangId;
	},

	url: function() {
		return '/api/gang-types/' + this.gangId + '/roles';
	}

});