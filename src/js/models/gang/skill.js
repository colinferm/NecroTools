Necro.Models.SkillSet = Backbone.Model.extend({
	urlRoot:     "/api/skill-set",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"skill_set_name": "",
        "limited_to_gang": "0",
		"gang_type_id": "0",
		"is_wyrd": 0,
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
		if (this.archetypeId) {
			return '/api/archetypes/' + this.archetypeId + '/sets/' + this.primary;

		} else if (this.roleId && this.primary != null) {
			return '/api/fighter/role/' + this.roleId + '/skills/' + this.primary;
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
	},

	getSkillSetsForGang(gangId) {
		var gId = parseInt(gangId);
		var sets = [];
		for (var i = 0; i < this.models.length; i++) {
			var set = this.models[i];
			if (!set.attributes.limited_to_gang || (set.attributes.limited_to_gang && set.attributes.gang_type_id == gId)) {
				sets.push(set);
				continue;
			}
		}
		return sets;
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

Necro.Models.Archetype = Backbone.Model.extend({
	urlRoot:     "/api/archetype",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"archetype_name": "",
		"archetype_description": "",
		"is_wyrd": false,
		"primary_skills": null,
		"secondary_skills": null
	},

	initialize: function() {
		if (!this.attributes.primary_skills) {
			this.attributes.primary_skills = new Necro.Collections.SkillSets();
			this.attributes.primary_skills.archetypeId = this.id;
			this.attributes.primary_skills.primary = 1;
		}

		if (!this.attributes.secondary_skills) {
			this.attributes.secondary_skills = new Necro.Collections.SkillSets();
			this.attributes.secondary_skills.archetypeId = this.id;
			this.attributes.secondary_skills.primary = 0;
		}
	},

	parse: function(resp) {
		var pskills = new Necro.Collections.SkillSets();
		var sskills = new Necro.Collections.SkillSets();

		pskills.archetypeId = this.id;
		pskills.primary = 0;
		sskills.archetypeId = this.id;
		sskills.primary = 0;

		resp.primary_skills = new Necro.Collections.SkillSets(resp.primary_skills, {parse: true});
		resp.secondary_skills = new Necro.Collections.SkillSets(resp.secondary_skills, {parse: true});

		/* _.each(resp.primary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			pskills.push(skillSet);
		}, this);

		_.each(resp.secondary_skills, function(s) {
			var skillSet = new Necro.Models.SkillSet(s, {parse: true});
			sskills.push(skillSet);
		}, this);

		resp.primary_skills = pskills;
		resp.secondary_skills = sskills; */

		return resp;
	}
});

Necro.Collections.Archetypes = Backbone.Collection.extend({
	model: Necro.Models.Archetype,
	url:   '/api/archetypes',

	initialize: function() {
		this.comparator = "archetype_name";
	},

	parse: function(resp) {
		this.add(resp);
		return resp;
	}
});