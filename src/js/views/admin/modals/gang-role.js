Necro.Views.Admin.GangRoleEditModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-gang-role',

	events: {
		
	},

	render: function() {
		var template = this.model.get("template");
		if (!template) {
			template = new Necro.Models.FighterTemplate({gang_type_id: this.model.get('gang_type_id'), fighter_role: this.model.id});
			this.model.set("template", template);
		}
		this.$el.html(this.template({model: this.model.toJSON(), template: template.toJSON(), roles: Necro.Apps.Data.RoleClasses}));
		return this;
	},

	save: function(callback) {
		let roleNameField = $('.role_name', this.$el);
		let baseValueField = $('.base_value', this.$el)
		let hierarchy = $('[name="hierarchy_role"]', this.$el).val();

		let numStartSkills = $('.num_start_skills', this.$el).val();
		if (!numStartSkills) numStartSkills = 0;

		var isVehicle = ($('.isVehicle', this.$el).is(':checked')) ? 1 : 0;
		var isDramatis = ($('.isDramatis', this.$el).is(':checked')) ? 1 : 0;
		
		let roleName = roleNameField.val();
		if (!roleName || roleName.length < 3) {
			roleNameField.addClass('error');
			return;
		} else {
			roleNameField.removeClass('error');
		}

		let baseValue = baseValueField.val();
		if (!baseValue || baseValue.length < 1) {
			baseValueField.addClass('error');
			return;
		} else {
			baseValueField.removeClass('error');
		}

		var m = this.model;
		m.set("role_name", roleName);
		m.set("hierarchy_role", hierarchy);

		var t = this.model.get("template");
		t.set("base_value", baseValue);
		t.set("num_start_skills", numStartSkills);
		t.set("is_vehicle", isVehicle);
		t.set("is_dramatis", isDramatis);

		//console.log(m.toJSON());

		/* m.save(null, {
			success: function() {
				callback(true, m);
			},
			error: callback(false)
		}); */

		m.save(null, {
			success: function(mo, r, o) {
				t.set("fighter_role", m.id);
				t.save(null, {
					success: callback(true, m),
					error: callback(false)
				})
			},
			error: function(mo, r, o) {
				console.log(r);
				callback(false);
			}
		});
	}

});