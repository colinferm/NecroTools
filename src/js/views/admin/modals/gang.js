Necro.Views.AdminGangEditModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-gang-template',

	events: {
		'click .save_button': 'save'
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	save: function(callback) {
        var m = this.model;
        m.set("skill_name", $('.skill_name', this.$el).val());
        m.set("skill_description", $('.skill_description', this.$el).val());

        m.save({
            success: callback(true, m),
            error: callback(false)
        });
	}

});