Necro.Views.User.EditFighter = Backbone.View.extend({
	tagName: 'div',
	className: 'ms-3 me-3 bg-light',
	templateName: 'edit-user-fighter',
	pageTitle: 'Edit Fighter',

	events: {
		'click .add_equipment': 'addEquipment',
		'click .add_skills': 'addSkills',
		'click .add_advancement': 'addAdvancement',
		'click .add_injury': 'addInjury',
		'click .add_note': 'addNote',
		'click .action_kill': 'killFighter',
		'click .action_retire': 'retireFighter',
		'click .action_recovery': 'sendToRecovery',
		'click .action_delete': 'deleteFighter'
	},

	initialize: function(options) {
		this.model = options.model;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		window.scrollTo({top: 0});
		return this;
	},

	addEquipment: function() {
		console.log("Add Equipment");
	},

	addSkills: function() {
		console.log("Add Skills");
	},

	addAdvancement: function() {
		console.log("Add Advancement");
	},

	addInjury: function() {
		console.log("Add Injury");
	},

	addNote: function() {
		console.log("Add Note");
	},

	killFighter: function() {
		console.log("Kill Fighter");
	},

	retireFighter: function() {
		console.log("Retire Fighter");
	},

	sendToRecovery: function() {
		console.log("Send to Recovery");
	},

	deleteFighter: function() {
		console.log("Delete Fighter");
	}

});
