Necro.Views.Admin.GangEdit = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12 grid-x',
	templateName: 'gang-template-edit',
	pageTitle: 'Edit',
	model: null,

	events: {
	},

	initialize : function(options) {
		this.pageTitle = "Edit " + this.model.get("type_name") + " Fighter List";
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		
	},

	render: function() {
		this.$el.html(this.template({ model: this.model.toJSON() }));
		this.roleTable = new Necro.Views.Admin.GangRoleList({ el: $('.role-list', this.$el), model: this.model }).render();

		return this;
	},

	

});