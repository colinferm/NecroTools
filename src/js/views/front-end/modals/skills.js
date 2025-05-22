Necro.Views.User.Modal.AddSkills = Necro.Views.BaseModal.extend({
	templateName: 'modal-skills',

	events: {
		"change .skill_box": "addSkill"
	},

	render: function() {
		this.$el.html(this.template({skillsets: Necro.Apps.Data.SkillSets.toJSON(), model: this.model.toJSON()}));
		return this;
	},

	addSkill: function(e) {
		//console.log(e);
		var target = $(e.currentTarget);
		var checked = target.is(':checked');
		var skillId = target.val();
		//console.log("Checked: " + checked + ", Skill: " + skillId);
		var skill = Necro.Apps.Data.SkillSets.getSkill(skillId)
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