Necro.Views.Admin.Modal.StatLine = Necro.Views.BaseModal.extend({
	templateName: 'modal-stat-line',

	events: {
	},

	render: function() {
		this.$el.html(this.template({model: this.model.toJSON()}));
		return this;
	},

	save: function(callback) {
		var movement = $('[name="movement"]', this.$el).val();
		var weaponSkill = $('[name="weapon_skill"]', this.$el).val();
		var balisticSkill = $('[name="balistic_skill"]', this.$el).val();
		var strength = $('[name="strength"]', this.$el).val();
		var toughness = $('[name="toughness"]', this.$el).val();
		var wounds = $('[name="wounds"]', this.$el).val();
		var initiative = $('[name="initiative"]', this.$el).val();
		var attacks = $('[name="attacks"]', this.$el).val();
		var leadership = $('[name="leadership"]', this.$el).val();
		var cool = $('[name="cool"]', this.$el).val();
		var willpower = $('[name="willpower"]', this.$el).val();
		var intelligence = $('[name="intelligence"]', this.$el).val();


		var m = this.model;
		m.set("movement", movement);
		m.set("weapon_skill", weaponSkill);
		m.set("balistic_skill", balisticSkill);
		m.set("strength", strength);
		m.set("toughness", toughness);
		m.set("wounds", wounds);
		m.set("initiative", initiative);
		m.set("attacks", attacks);
		m.set("leadership", leadership);
		m.set("cool", cool);
		m.set("willpower", willpower);
		m.set("intelligence", intelligence);

		m.save({
			success: callback(true, m),
			error: callback(false)
		});
	}

});