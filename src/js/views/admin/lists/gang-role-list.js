Necro.Views.Admin.GangRoleList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'gang-role-list',
	model: null,

	events: {
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
        this.collection = new Necro.Collections.GangRoles({gangId: this.model.get('id')});
		this.collection.fetch({ success: _.bind(this.addItems, this) });
	},

	render: function() {
		this.$el.html(this.template);
		if (this.collection && this.collection.length > 0) this.addItems();
		return this;
	},

	addItems: function() {
		$('tbody', this.$el).empty()
		_.each(this.collection.models, function(model) {
			this.addItem(model);
		}, this);
	},

	addItem: function(item) {
		var row = new Necro.Views.Admin.GangRoleListItem({model: item});
		$('tbody', this.$el).append(row.render().$el);
	}

});

Necro.Views.Admin.GangRoleListItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'gang-role-list-item',

	events: {
		'click .action_primary': 'addPrimarySkills',
		'click .action_secondary': 'addSecondarySkills',
		'click .action_remove': 'deleteGang',
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("change", this.render, this);
		this.model.on("destroy", this.remove, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));
		return this;
	},

	addPrimarySkills: function() {
		this.popSkillSetModal(true);
	},

	addSecondarySkills: function() {
		this.popSkillSetModal(false);
	},

	popSkillSetModal: function(primary) {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.AssignSkillSet",
			title: "Assign Skill Set",
			model: this.model,
			primarySkill: primary
		});
	},

	deleteGang: function() {
		this.model.destroy();
	}

});