Necro.Views.User.Modal.AddInjury = Necro.Views.BaseModal.extend({
	templateName: 'modal-add-injury',

	events: {
		'change .injury_selector': 'populateDescription'
	},

	render: function() {
		//this.$el.html(this.template(this.model.toJSON()));
		this.$el.html(this.template({injuries: Necro.Apps.Data.Injuries, model: this.model.toJSON()}));
		return this;
	},

	populateDescription: function() {
		var val = $('.injury_selector', this.$el).val();
		for (var i = 0; i < Necro.Apps.Data.Injuries.length; i++) {
			this.inj = Necro.Apps.Data.Injuries[i];
			if (this.inj.id == val) break;
		}
		$('.injury_result', this.$el).html("Result: <b>"+this.inj.description+"</b>");
	},

	save: function(cb) {
		if (this.inj) {
			console.log("Saving injury: " + this.inj.name);
		}
		cb(true, this.inj);
	}

});