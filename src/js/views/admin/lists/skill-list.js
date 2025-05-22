Necro.Views.Admin.SkillList = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	templateName: 'skill-list',
	pageTitle: 'Fighter Skills',

	events: {
		'click .addSkillSet': 'addSkillSet'
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		this.collection = new Necro.Collections.SkillSets({});
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
		var row = new Necro.Views.Admin.SkillSet({model: item});
		$('.skill-sets', this.$el).append(row.render().$el);
	},

	addSkillSet: function() {
		var m = new Necro.Models.SkillSet();
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.EditSkillSetModal",
			title: "Add Skill Set",
			model: m,
			callback: _.bind(function() {
				if (m) this.collection.add(m);
			}, this)
		});
	}

});

Necro.Views.Admin.SkillSet = Backbone.View.extend({
    tagName: 'table',
    className: 'table table-striped skill-list',
    templateName: 'skill-list-set',

	events: {
		'click .action_edit': 'editSkillSet',
		'click .action_add': 'addNewSkill',
		'click .child-content': 'reveal'
	},

    initialize: function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("sync", this.render, this);
		var collection = this.model.attributes.skills;
		collection.on('add', this.addItem, this);
	},

	render: function() {
		var table = null;
		if ($('tbody', this.$el).length) table = $('tbody',this.$el).detach();

		this.$el.html(this.template(this.model.toJSON()));
		//var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));

		if (table) {
			this.$el.append(table);
		} else {
			this.$el.append('<tbody class="d-none"></tbody>');
			_.each(this.model.attributes.skills.models, function(skill) {
				this.addItem(skill);
			}, this);
		}

		return this;
	},

	addItem: function(skill) {
		var item = new Necro.Views.Admin.SkillItem({model: skill});
		$('tbody', this.$el).append(item.render().$el);
	},

	editSkillSet: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.EditSkillSetModal",
			title: "Edit Skill Set",
			model: this.model
		});
	},

	addNewSkill: function() {
		var skillSet = this.model.get('skill_set_name');
		var m = new Necro.Models.Skill({skill_set_id: this.model.get('id'), skill_set_name: skillSet});
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.SkillEditModal",
			title: "Add " + skillSet + " Skill",
			model: m,
			callback: _.bind(function() {
				if (m) {
					var collection = this.model.attributes.skills;
					collection.add(m);
				}
			}, this)
		});
	},

	reveal: function() {
		$('tbody', this.$el).toggleClass('d-none');
	}

});

Necro.Views.Admin.SkillItem = Backbone.View.extend({
	tagName: 'tr',
	templateName: 'skill-list-item',

	events: {
		'click .skill_name': 'editSkill',
		'click .action_edit_skill': 'editSkill',
		'click .action_remove_skill': 'deleteSkill',
	},

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.model.on("sync", this.render, this);
		this.model.on("destroy", this.remove, this);
	},

	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		//var menu = new Foundation.DropdownMenu($('ul.dropdown.menu', this.$el));
		return this;
	},

	editSkill: function() {
		var modal = new Necro.Views.Modal({
			class: "Necro.Views.Admin.SkillEditModal",
			title: "Edit Skill",
			model: this.model
		});
	},

	deleteSkill: function() {
		this.model.destroy();
	}

});