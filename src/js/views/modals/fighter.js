Necro.Views.FighterModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-fighter',

	events: {
	},

	render: function() {
		var roles;
		var fighterRole;
		for (var i = 0; i < Necro.Apps.Data.FighterRoles.length; i++) {
			var gangRoles = Necro.Apps.Data.FighterRoles[i];
			if (gangRoles.gang_type_id == this.model.get('user_gang_id')) {
				roles = gangRoles;
				for (var ii = 0; ii < gangRoles.roles.length; ii++) {
					fighterRole = gangRoles.roles[ii];
					if (fighterRole.id == this.model.get('fighter_role_id')) break;
				}
				break;
			}
		}
		this.$el.html(this.template({roles: roles.roles, fighterRole: fighterRole, model: this.model.toJSON()}));
		return this.$el;
	},

	save: function(cb) {
		cb(true);
	}
});

Handlebars.registerHelper("form-option", function(options) {
	var model = options.data.root.model;
	var selected = "";
	if (this.id == model.fighter_role_id) selected = "selected";
	return '<option value="' + this.id + '" ' + selected + '>' + this.role_name + '</option>';
});