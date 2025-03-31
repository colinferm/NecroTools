Necro.Views.Roster = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'roster-list',
	pageTitle: 'Gang',

	events: {
		
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

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
		$('tbody', this.el).empty()
		_.each(this.model.get("fighters").models, function(model) {
			var item = new Necro.Views.RosterItem({model: model});
			$('tbody', this.el).append(item.render().$el);
		});
		Necro.Events.trigger('stylize');
		Necro.Events.trigger("roster_updated", this.collection);
	}

});


Necro.Views.RosterItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'roster-list-item',

	events: {
		'click .action_edit': 'editFighter',
		'click .action_clone': 'cloneFighter',
		'click .action_xp': 'addXP',
		'click .action_injure': 'injureFighter',
		'click .action_kill': 'killFighter',
		'click .action_remove': 'removeFighter'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.fetch({
			success: _.bind(this.render, this)
		});
		this.model.on("change", _.bind(this.render, this));
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		Necro.Events.trigger('stylize');
		return this;
	},

	editFighter: function() {
		console.log("Edit Fighter: " + this.model.get('fighter_name'));
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.FighterModal",
			title: "Edit Fighter",
			model: this.model
		});
	},

	cloneFighter: function() {
		console.log("Clone Fighter");
	},

	addXP: function() {
		console.log("Add XP");
		var modal = new Necro.Views.Modal({
			class: 'Necro.Views.XPModal',
			title: "Add XP",
			model: this.model
		});
	},

	injureFighter: function() {
		console.log("Injure Fighter");
		var modal = new Necro.Views.Modal({
			class: 'Necro.Views.InjuryModal',
			title: 'Add Injury',
			model: this.model
		});
	},

	killFighter: function() {
		console.log("Kill Fighter");
		var modal = new Necro.Views.Modal({
			class: 'Necro.Views.SkillsModal',
			title: 'Select Skills',
			model: this.model
		});
	},

	removeFighter: function() {
		console.log("Remove Fighter");
	}

});