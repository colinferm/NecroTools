Necro.Views.Admin.ArchetypeList = Necro.Views.BaseListView.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'archetype-list',
	pageTitle: 'Fighter Archetypes',
	searchKey: 'archetype_name',

	events: _.extend({
		'click .addArchetype': 'addArchetype',
	}, Necro.Views.BaseListView.prototype.events),

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.Archetypes({});
		this.collection.on("add", this.addItem, this);
		this.collection.fetch();
	},

	addItems: function(items) {
		if (!items) items = this.collection.models;
		$('tbody', this.$el).empty()
		_.each(items, function(model) {
			this.addItem(model);
		}, this);
	},

	addItem: function(item) {
		var row = new Necro.Views.Admin.ArchetypeItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	},

	addArchetype: function() {
		var m = new Necro.Models.Archetype();
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.EditArchetype",
			title: "Add Archetype",
			model: m,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}

});

Necro.Views.Admin.ArchetypeItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'archetype-list-item',

	events: {
		'click .trait_name': 'editTrait',
		'click .action_edit': 'editArchetype',
		'click .action_remove': 'deleteArchetype',
		'click .action_primary': 'addPrimarySkills',
		'click .primary_skills': 'addPrimarySkills',
		'click .action_secondary': 'addSecondarySkills',
		'click .secondary_skills': 'addSecondarySkills'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("change", this.render, this);
		this.model.on("destroy", this.remove, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		//var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));
		return this;
	},

	editArchetype: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.EditArchetype",
			title: "Edit Archetype",
			model: this.model
		});
	},

	deleteArchetype: function() {
		this.model.destroy();
	},

	addPrimarySkills: function() {
		this.popSkillSetModal(true);
	},

	addSecondarySkills: function() {
		this.popSkillSetModal(false);
	},

	popSkillSetModal: function(primary) {
		var title = "Assign Primary Skills";
		if (!primary) {
			title = "Assign Secondary Skills";
		}
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.Modal.AssignSkillSet",
			title: title,
			model: this.model,
			primarySkill: primary
		});
	},

});