Necro.Views.User.Modal.AddGang = Necro.Views.BaseModal.extend({
	templateName: 'modal-add-gang',

	events: {
	},

	render: function() {
		//this.$el.html(this.template(this.model.toJSON()));
		this.$el.html(this.template({
			gangs: Necro.Apps.Data.GangTypes, 
			model: this.model.toJSON()
		}));
		return this;
	},

	save: function(callback) {
		
	}

});