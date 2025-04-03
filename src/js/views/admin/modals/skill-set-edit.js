Necro.Views.SkillSetModal = Necro.Views.BaseModal.extend({
	templateName: 'modal-edit-skill-set',

	events: {
		'click .save_button': 'save'
	},

	render: function() {
		this.$el.html(this.template({gangTypes: Necro.Apps.Data.GangTypes, model: this.model.toJSON()}));
		return this;
	},

	save: function(callback) {
        var m = this.model;
        var limited = ($('.limited_to_gang', this.$el).is(":checked")) ? 1 : 0;
        var gang_id = (!limited) ? 0 : $('#gang_type_id', this.$el).val();
        m.set("skill_set_name", $('.skill_set_name', this.$el).val());
        m.set("limited_to_gang", limited);
        m.set("gang_type_id", gang_id);

        m.save({
            success: callback(true, m),
            error: callback(false)
        });
	}

});