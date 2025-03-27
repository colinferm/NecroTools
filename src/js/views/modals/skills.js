Necro.Views.SkillsModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-skills',

	events: {
	},

	render: function() {
		this.$el.html(this.template({injuries: Necro.Apps.Data.Injuries, model: this.model.toJSON()}));
		return this.$el;
	},

	save: function(cb) {
		if (this.inj) {
			console.log("Saving injury: " + this.inj.name);
		}
		cb(true);
	}

});