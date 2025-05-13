Necro.Views.Admin.GangRoleEditModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-gang-role',

	events: {
		'click .save_button': 'save'
	},

	render: function() {
		this.$el.html(this.template({model: this.model.toJSON(), roles: Necro.Apps.Data.RoleClasses}));
		return this;
	},

	save: function(callback) {
		let roleNameField = $('.role_name', this.$el);
		let hierarchy = $('[name="hierarchy_role"]', this.$el).val();
		let roleName = roleNameField.val();

		if (!roleName || roleName.length < 3) {
			roleNameField.addClass('error');
			return;
		} else {
			roleNameField.removeClass('error');
		}
		var m = this.model;
        m.set("role_name", roleName);
        m.set("hierarchy_role", hierarchy);

		console.log(m.toJSON());

        m.save({
            success: callback(true, m),
            error: callback(false)
        });
	}

});