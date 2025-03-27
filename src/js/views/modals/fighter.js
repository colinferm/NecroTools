Necro.Views.FighterModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-fighter',

	events: {
	},

	render: function() {
		this.$el.html(this.template({model: this.model.toJSON()}));
		return this.$el;
	},

	save: function(cb) {
		cb(true);
	}

});