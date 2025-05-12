Necro.Models.SkillSet = Backbone.Model.extend({
	urlRoot:     "/api/skill-set",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"skill_set_name": "",
        "limited_to_gang": "0",
		"gang_type_id": "0",
		"gang_name": "",
		"skills": Necro.Collections.Skills,
	},
	parse: function(resp) {
		//console.log(resp);
		this.attributes.skills = new Necro.Collections.Skills();
		_.each(resp.skills, function(s) {
			var skill = new Necro.Models.Skill(s, {parse: true});
			this.attributes.skills.add(skill);
		}, this);
		delete resp.skills;
		return resp;
	},
});

Necro.Collections.SkillSets = Backbone.Collection.extend({
	model: Necro.Models.SkillSet,

	url: function() {
		if (this.roleId && this.primary != null) {
			return '/api/fighter/role/' + this.roleId + '/' + this.primary + '/skills';
		}
		return '/api/skills';
	},

	initialize: function() {
		this.comparator = "skill_set_name";
	},

	parse: function(resp) {
		console.log(resp);
		this.add(resp, {silent: true});
		return resp;
	},

	getSkill: function(id) {
		var skillId = parseInt(id);
		var skill;
		this.models.forEach(function(ss){
			ss.attributes.skills.forEach(function(s){
				if (s.id == skillId) {
					skill = s;
				}
			});
		});
		return skill;
	}
});

Necro.Models.Skill = Backbone.Model.extend({
	urlRoot:     "/api/skill",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"skill_name": "",
		"skill_set_id": 0,
		"skill_set_name": "",
		"skill_description": ""
	}
});

Necro.Collections.Skills = Backbone.Collection.extend({
	model: Necro.Models.Skill,
	url:   '/api/skill',

	initialize: function() {
		this.comparator = "skill_name";
	},

	parse: function(resp) {
		console.log(resp);
		this.add(resp);
		return resp;
	}
});