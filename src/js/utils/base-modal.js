Necro.Views.BaseModal = Backbone.View.extend({
	class: "row",

	events: {
		'change .form-control': 'validate',
		'focusout .form-control': 'validate'
	},

	initialize : function(options) {
		this.opts = options;
		this.model = options.model;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
	},

	validate: function(e) {
		let field = $(e.currentTarget);
		if (this.checkValidation) this.checkValidation(field);
		if ($('.is-invalid', this.$el).length == 0) {
			$('.validation-alert', this.el).removeClass('d-block').addClass('d-none');
		}
	},

	doSave: function(callback) {
		if ($('.is-invalid', this.$el).length) {
			$('.validation-alert', this.el).addClass('d-block').removeClass('d-none');
			return;
		}
		if (this.save) this.save(callback);
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