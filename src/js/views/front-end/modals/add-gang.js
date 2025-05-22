Necro.Views.User.Modal.AddGang = Necro.Views.BaseModal.extend({
	templateName: 'modal-add-gang',

	events: {
	},

	render: function() {
		this.$el.html(this.template({
			model: this.model.toJSON()
		}));
		return this;
	},

	save: function(callback) {
		
	}

});