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
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		Necro.Events.trigger('stylize');
		return this.$el;
	},

	editFighter: function() {
		console.log("Edit Fighter: " + this.model.get('fighter_name'));
	},

	cloneFighter: function() {
		console.log("Clone Fighter");
	},

	addXP: function() {
		console.log("Add XP");
	},

	injureFighter: function() {
		console.log("Injure Fighter");
	},

	killFighter: function() {
		console.log("Kill Fighter");
	},

	removeFighter: function() {
		console.log("Remove Fighter");
	}

});