Necro.Views.AdminSkillList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'skill-list',
	pageTitle: 'Skills',

	events: {
		'click .addSkillSet': 'addSkillSet'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Models.SkillSetCollection({});
		this.collection.fetch({
			success: _.bind(this.addItems, this)
		});
		this.collection.on("add", this.addItem, this);
	},

	render: function() {
		this.$el.html(this.template);
		return this;
	},

	addItems: function() {
		$('skill-sets', this.$el).empty()
		_.each(this.collection.models, function(item) {
			this.addItem(item);
		}, this);
	},

	addItem: function(item) {
		var row = new Necro.Views.AdminSkillSet({model: item});
		$('.skill-sets', this.$el).append(row.render().$el);
	},

	addSkillSet: function() {
		var m = new Necro.Models.SkillSet();
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.SkillSetModal",
			title: "Add Skill Set",
			model: m,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}

});

Necro.Views.AdminSkillSet = Backbone.View.extend({
    tagName: 'table',
    className: 'hover skill-list',
    templateName: 'skill-list-set',

	events: {
		'click .action_edit': 'editSkillSet'
	},

    initialize: function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("sync", this.render, this);
	},

	render: function() {
		var table = null;
		if ($('tbody', this.$el).length) table = $('tbody',this.$el).detach();

		this.$el.html(this.template(this.model.toJSON()));
		var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));

		if (table) {
			this.$el.append(table);
		} else {
			this.$el.append('<tbody></tbody>');
			_.each(this.model.attributes.skills, function(skill) {
				var item = new Necro.Views.AdminSkillItem({model: new Necro.Models.Skill(skill)});
				$('tbody', this.$el).append(item.render().$el);
			}, this);
		}

		return this;
	},

	editSkillSet: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.SkillSetModal",
			title: "Edit Skill Set",
			model: this.model
		});
	}

});

Necro.Views.AdminSkillItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'skill-list-item',

	events: {
		'click .action_edit': 'editSkill',
		'click .action_remove': 'deleteSkill',
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("change", this.render, this);
		//this.model.on("destroy", this.remove, this);
	},

	render: function() {
		//console.log(this.model.toJSON());
		this.$el.html(this.template(this.model.toJSON()));
		var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));
		return this;
	},

	editSkill: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.AdminSkillEditModal",
			title: "Edit Skill",
			model: this.model
		});
	},

	deleteSkill: function() {
		this.model.destroy();
	}

});