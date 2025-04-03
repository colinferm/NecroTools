Necro.Models.SkillSet = Backbone.Model.extend({
	urlRoot:     "/api/skill-set",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"skill_set_name": "",
        "limited_to_gang": "0",
		"gang_type_id": "0",
		"gang_name": "",
		"skills": Necro.Models.SkillCollection,
	},
	parse: function(resp) {
		console.log(resp);
		return resp;
	},
});

Necro.Models.SkillSetCollection = Backbone.Collection.extend({
	model: Necro.Models.SkillSet,
	url:   '/api/skills',

	initialize: function() {
		this.comparator = "skill_set_name";
	},

	parse: function(resp) {
		console.log(resp);
		this.add(resp);
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
	urlRoot:     "/api/skills",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"skill_name": ""
	}
});

Necro.Models.SkillCollection = Backbone.Collection.extend({
	model: Necro.Models.Skill,
	url:   '/api/skills',

	initialize: function() {
		this.comparator = "skill_name";
	},

	parse: function(resp) {
		console.log(resp);
		this.add(resp);
		return resp;
	}
});