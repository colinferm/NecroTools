Necro.Views.Admin.AssignSkillSet = Necro.Views.BaseModal.extend({
	templateName: 'modal-assign-skill-set',

	events: {
		"change .skill_set_box": "addSkillSet"
	},

	initialize : function(options) {
		this.options = options;
		
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		//this.$el.html(this.template({skillsets: Necro.Apps.Data.SkillSets.getSkillSetsForGang().toJSON(), model: this.model.toJSON(), primary: this.options.primarySkill }));
		var ss = Necro.Apps.Data.SkillSets.getSkillSetsForGang(this.model.get("gang_type_id"));
		var passed = JSON.stringify(ss);
		this.$el.html(this.template({skillsets: ss, model: this.model.toJSON(), primary: this.options.primarySkill }));
		return this;
	},

	skillSet: function() {
		var modelSet = null;
		if (this.options.primarySkill) {
			modelSet = this.model.attributes.primary_skills;
			modelSet.primary = 1;
		} else {
			modelSet = this.model.attributes.secondary_skills;
			modelSet.primary = 0;
		}
		return modelSet;
	},

	addSkillSet: function(e) {
		//console.log(e);
		var target = $(e.currentTarget);
		var checked = target.is(':checked');
		var skillSetId = target.val();
		var skillset = Necro.Apps.Data.SkillSets.get(skillSetId);

		var modelSet = this.skillSet();
		
		if (checked) {
			modelSet.add(skillset);
		} else {
			modelSet.remove(skillset);
		}
	},

	save: function(cb) {
		var m = this.model;
		var modelSet = this.skillSet();
		if (modelSet) {
			var url = modelSet.url();
			modelSet.sync("update", modelSet, {
				success: _.bind(function() {
					cb(true, m);
				}, this)
			})
		}
	}

});