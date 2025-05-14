Necro.Models.GangRole = Backbone.Model.extend({
	idAttribute: "id",
	url: function() {
		if (this.id && this.id > 0) {
			return "/api/fighter/role/" + this.id;
		}
		return "/api/fighter/role";
	},
	defaults:    {
		"id": null,
		"hierarchy_role": "",
		"role_name": "",
		"gang_type_id": "",
		"gang": null,
		"template": null,
		"primary_skills": null,
		"secondary_skills": null
	},

	initialize: function(options) {
		if (!this.attributes.primary_skills) {
			this.attributes.primary_skills = new Necro.Collections.SkillSets();
			this.attributes.primary_skills.roleId = this.id;
		}

		if (!this.attributes.secondary_skills) {
			this.attributes.secondary_skills = new Necro.Collections.SkillSets();
			this.attributes.secondary_skills.roleId = this.id;
		}
	},

	parse: function(resp) {
		var pskills = new Necro.Collections.SkillSets();
		var sskills = new Necro.Collections.SkillSets();

		pskills.roleId = resp.id;
		sskills.roleId = resp.id;

		/* var pskills = [];
		var sskills = []; */
		_.each(resp.primary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			pskills.push(skillSet);
		}, this);

		_.each(resp.secondary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			sskills.push(skillSet);
		}, this);

		if (resp.template) {
			var template = new Necro.Models.FighterTemplate(resp.template);
			template.set({gang_type_id: resp.gang_type_id, fighter_role: resp.id});
			resp.template = template;
		}

		resp.primary_skills = pskills;
		resp.secondary_skills = sskills;
		return resp;
	},
});

Necro.Models.FighterTemplate = Backbone.Model.extend({
	idAttribute: "template_id",
	url: function() {
		let roleId = this.attributes.fighter_role;
		return "/api/fighter/role/" + roleId + "/stats";
	},
	defaults:    {
		"template_id": null,
		"movement": null,
		"weapon_skill": null,
		"balistic_skill": null,
		"strength": null,
		"toughness": null,
		"toughness_side": null,
		"toughness_rear": null,
		"wounds": null,
		"initiative": null,
		"attacks": null,
		"handling": null,
		"save_roll": null,
		"leadership": null,
		"cool": null,
		"willpower": null,
		"intelligence": null,
		"num_start_skills": 0,
		"is_vehicle": 0,
		"is_dramatis": 0,
		"base_value": 0,
		"view_order": 0,
		"created": null,
		"last_mod": null

	},

	initialize: function(options) {
	},

	parse: function(resp) {
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