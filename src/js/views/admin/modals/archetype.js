Necro.Views.Admin.Modal.EditArchetype = Necro.Views.BaseModal.extend({
	templateName: 'modal-archetype',

	events: {
		"change .primary_skill_set_box": "togglePrimarySkillSet",
		"change .secondary_skill_set_box": "toggleSecondarySkillSet"
	},

	render: function() {
		var skillsets = Necro.Apps.Data.SkillSets.getSkillSetsForGang(this.model.get("gang_type_id"));
		this.$el.html(this.template({
			archetype_name: this.model.get("archetype_name"),
			archetype_description: this.model.get("archetype_description"),
			is_wyrd: this.model.get("is_wyrd"),
			skillsets: skillsets
		}));

		this.checkSkillSets();
		return this;
	},

	checkSkillSets: function() {
		var primarySkills = this.model.attributes.primary_skills;
		var secondarySkills = this.model.attributes.secondary_skills;

		if (primarySkills) {
			primarySkills.each(function(skillSet) {
				$('.primary_skill_set_box[value="' + skillSet.id + '"]', this.$el).prop('checked', true);
			}, this);
		}

		if (secondarySkills) {
			secondarySkills.each(function(skillSet) {
				$('.secondary_skill_set_box[value="' + skillSet.id + '"]', this.$el).prop('checked', true);
			}, this);
		}
	},

	togglePrimarySkillSet: function(e) {
		var target = $(e.currentTarget);
		var checked = target.is(':checked');
		var skillSetId = target.val();
		var skillset = Necro.Apps.Data.SkillSets.get(skillSetId);
		var modelSet = this.model.attributes.primary_skills;

		if (checked) {
			modelSet.add(skillset);
		} else {
			modelSet.remove(skillset);
		}
	},

	toggleSecondarySkillSet: function(e) {
		var target = $(e.currentTarget);
		var checked = target.is(':checked');
		var skillSetId = target.val();
		var skillset = Necro.Apps.Data.SkillSets.get(skillSetId);
		var modelSet = this.model.attributes.secondary_skills;

		if (checked) {
			modelSet.add(skillset);
		} else {
			modelSet.remove(skillset);
		}
	},

	checkValidation: function(field) {
		if (field.hasClass('archetype_name') && field.val().length < 5) {
			field.addClass('is-invalid');
			return;
		}

		field.removeClass('is-invalid').addClass('is-valid');
	},

	/* syncSkillSets: function(callback) {
		var m = this.model;
		var primarySkills = m.attributes.primary_skills;
		var secondarySkills = m.attributes.secondary_skills;

		primarySkills.archetypeId = m.id;
		primarySkills.primary = 1;
		secondarySkills.archetypeId = m.id;
		secondarySkills.primary = 0;

		primarySkills.sync("update", primarySkills, {
			success: function() {
				secondarySkills.sync("update", secondarySkills, {
					success: function() {
						callback(true, m);
					}
				});
			}
		});
	}, */

	save: function(callback) {
		var m = this.model;
		m.set("archetype_name", $('.archetype_name', this.$el).val());
		m.set("archetype_description", $('.archetype_description', this.$el).val());

		var isWyrd = ($(".is_wyrd", this.$el).is(':checked')) ? 1 : 0;
		m.set("is_wyrd", isWyrd);

		var self = this;
		m.save(null, {
			success: function() {
				//self.syncSkillSets(callback);
				callback(true, m);
			},
			error: function() {
				callback(false);
			}
		});
	}

});
