Necro.Views.SkillsModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-skills',

	events: {
		"change .skill_box": "addSkill"
	},

	render: function() {
		this.$el.html(this.template({skillsets: Necro.Apps.Data.Skills.toJSON(), model: this.model.toJSON()}));
		return this;
	},

	addSkill: function(e) {
		//console.log(e);
		var target = $(e.currentTarget);
		var checked = target.is(':checked');
		var skillId = target.val();
		//console.log("Checked: " + checked + ", Skill: " + skillId);
		var skill = Necro.Apps.Data.Skills.getSkill(skillId)
		if (checked) {
			this.model.attributes.skills.add(skill);
		} else {
			this.model.attributes.skills.remove(skill);
		}
		console.log(this.model);
	},

	save: function(cb) {
		if (this.inj) {
			console.log("Saving injury: " + this.inj.name);
		}
		cb(true, this.inj);
	}
});

Handlebars.registerHelper("checkbox", function(options) {
	var model = options.data.root.model;
	var checked = "";
	model.skills.models.forEach(function(skill){
		if (skill.id == this.id) {
			checked = "checked";
			return;
		}
	});
	return '<input type="checkbox" class="skill_box" value="' + this.id + ' ' + checked + '">&nbsp;' + this.skill_name;
});