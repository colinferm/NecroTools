Necro.Models.SkillSet = Backbone.Model.extend({
	urlRoot:     "/api/skills",
	idAttribute: "id",
	defaults:    {
		"id": null,
		"skill_set_name": "",
        "limited_to_gang": "0",
		"skills": Necro.Models.SkillCollection,
	}
});

Necro.Models.SkillSetCollection = Backbone.Collection.extend({
	model: Necro.Models.SkillSet,
	url:   '/api/skills',
	parse: function(resp) {
		console.log(resp);
		this.add(resp);
		return resp;
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
	parse: function(resp) {
		console.log(resp);
		this.add(resp);
		return resp;
	}
});