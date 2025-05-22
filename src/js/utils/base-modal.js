Necro.Views.BaseModal = Backbone.View.extend({
	class: "row",

	initialize : function(options) {
		this.opts = options;
		this.model = options.model;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	save: function(callback) {
		callback(true);
	}
});

Necro.Views.BaseListView = Backbone.View.extend({
	tagName: 'div',
	className: 'large-12',
	searchKey: 'id',

	events: {
		'keyup': 'search'
	},

	search: function(e) {
		if (e.keyCode !== 16) {
			if ($('.search_input', this.$el).is(":focus")) {
				let search = $('.search_input', this.$el).val();
				let key = this.searchKey;
				let items = this.collection.filter(function(item) {
					var searchCol = item.attributes[key].toLowerCase();
					if (searchCol.includes(search.toLowerCase())) return 1;
					return 0;
				})
				this.addItems(items);
			}
		}
	},

	addItems: function(item) {},

	render: function() {
		this.$el.html(this.template);
		
		if (this.onRender) this.onRender();
		return this;
	}

});