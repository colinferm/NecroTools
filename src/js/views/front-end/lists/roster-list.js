Necro.Views.Roster = Necro.Views.BaseListView.extend({
	tagName: 'div',
	className: 'col-12',
	templateName: 'roster-list',
	pageTitle: 'Gang',

	events: _.extend({
		'click .add_fighter': 'addFighter'
	}, Necro.Views.BaseListView.prototype.events),

	onInitialize : function(options) {

		if (this.model.get("id")) {
			this.model.fetch({
				success: _.bind(this.addItems, this)
			});
		}
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	},

	addItems: function() {
		$('.roster-list', this.$el).empty()
		_.each(this.model.get("fighters").models, function(model) {
			this.addItem(model);
		}, this);
		Necro.Events.trigger("roster_updated", this.collection);
	},

	addItem: function(item) {
		var v = new Necro.Views.RosterItem({model: item});
		$('.roster-list', this.$el).append(v.render().$el);
	},

	addFighter: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.User.Modal.AddFighter",
			title: "Edit Fighter",
			model: new Necro.Models.Fighter(),
			modalSize: 'modal-lg'
		});
	}

});


Necro.Views.RosterItem = Necro.Views.BaseListItemView.extend({
	tagName: 'div',
	className: 'col-6 ps-3 pe-3 pb-3',
	templateName: 'roster-list-item',

	events: {
		'click .action_edit': 'editFighter',
		'click .action_clone': 'cloneFighter',
		'click .action_xp': 'addXP',
		'click .action_injure': 'injureFighter',
		'click .action_kill': 'killFighter',
		'click .action_remove': 'removeFighter'
	},

	onInitialize : function(options) {
		this.model.fetch({
			success: _.bind(this.render, this)
		});
		this.model.on("change", _.bind(this.render, this));
	},

	editFighter: function() {
		console.log("Edit Fighter: " + this.model.get('fighter_name'));
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.User.Modal.AddFighter",
			title: "Edit Fighter",
			modalSize: 'modal-lg',
			model: this.model
		});
	},

	cloneFighter: function() {
		console.log("Clone Fighter");
	},

	addXP: function() {
		console.log("Add XP");
		var modal = new Necro.Views.Modal({
			class: 'Necro.Views.User.Modal.AddXP',
			title: "Add XP",
			model: this.model
		});
	},

	injureFighter: function() {
		console.log("Injure Fighter");
		var modal = new Necro.Views.Modal({
			class: 'Necro.Views.User.Modal.AddInjury',
			title: 'Add Injury',
			model: this.model
		});
	},

	killFighter: function() {
		console.log("Kill Fighter");
		var modal = new Necro.Views.Modal({
			class: 'Necro.Views.User.Modal.AddSkills',
			title: 'Select Skills',
			model: this.model
		});
	},

	removeFighter: function() {
		console.log("Remove Fighter");
	}

});