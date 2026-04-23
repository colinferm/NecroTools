Necro.Views.BaseListView = Backbone.View.extend({
	templateName: '',
	tagName: 'div',
	className: 'large-12',
	searchKey: 'id',
	appendSelector: 'tbody',
	actionButtonText: 'Action Button',
	itemClassName: 'Necro.Views.BaseListItemView',
	filterCollection: null,
	filterProp: 'id',
	filterName: 'name',
	filterSelector: '.form-filter',
	sortCol: "id",
	sortDir: "ASC",
	
	events: {
		'keyup': 'search',
		'click .sort_col': 'sortColumn',
		'.action_button': 'handleActionButton'
	},
	
	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);

		_.bindAll(this, 
			'render', 'onRendered', 'search', 'addItems', 'addItem', 
			'handleActionButton', 'handleFilter'
		);

		if (this.onInitialize) this.onInitialize(options);
	},

	render: function() {
		var filters = [];
		_.each(this.filterCollection, function(item) {
			filters.push({
				id: item.id,
				name: item[this.filterName]
			});
		}, this);

		this.templateOpts = {
			actionButtonText: this.actionButtonText,
			filterOptions: filters
		};

		this.$el.html(this.template(this.templateOpts));
		if (this.onRender) this.onRender();
		return this;
	},

	onRendered: function() {
		var filter = this.$el.find(this.filterSelector);
		if (!this.filterCollection) {
			filter.parent().remove();
			return;
		}
		filter.on('change', this.handleFilter);
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

	addItems: function(items) {
		if (!items) items = this.collection.models;
		$(this.appendSelector, this.$el).empty()
		_.each(items, function(item) {
			this.addItem(item);
		}, this);
	},
	
	addItem: function(item) {
		if (this.beforeAddItem) this.beforeAddItem(item)
		var view = Necro.Utils.Resolver.getNewInstance(this.itemClassName, {model: item});
		$(this.appendSelector, this.$el).append(view.render().$el);
	},
	
	handleActionButton: function(e) {
		if (this.handleAction) this.handleAction();
	},

	handleFilter: function(e) {
		//console.log(e);
		let selectedVal = $(e.currentTarget).find(':selected').val();
		//console.log(selectedVal);
		if (selectedVal.length == 0) {
			this.addItems();
			return;
		}

		let items = this.collection.filter(function(item) {
			if (this.filterProp.includes("id")) {
				var searchCol = item.attributes[this.filterProp];
				if (searchCol == selectedVal) return 1;
			} else {
				var searchCol = item.attributes[this.filterProp].toLowerCase();
				if (searchCol.includes(selectedVal.toLowerCase())) return 1;
			}
			return 0;
		}, this)
		this.addItems(items);
	},

	sortColumn: function(e) {
		let target = $(e.currentTarget);
		console.log(target);
		let sortCol = target.data("sortCol");
		console.log(sortCol);

		if (this.sortCol == sortCol) {
			if (this.sortDir == "ASC") {
				this.sortDir = "DESC";
			} else {
				this.sortDir = "ASC";
			}
		} else {
			this.sortDir = "ASC";
		}
		this.sortCol = sortCol;

		var col = this.sortCol;
		var dir = this.sortDir;
		this.collection.comparator = function(a, b) {
			var aVal = a.attributes[col];
			var bVal = b.attributes[col];
			if (aVal < bVal) return dir === 'DESC' ? 1 : -1;
			if (aVal > bVal) return dir === 'DESC' ? -1 : 1;
			return 0;
		};
		this.collection.sort();
		this.addItems(this.collection.models);
	}

});

Necro.Views.BaseListItemView = Backbone.View.extend({
	templateName: '',
	tagName: 'tr',
	
	events: {},
	
	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		if (this.model) {
			this.model.on("change", this.render, this);
			this.model.on("destroy", this.remove, this);
		}
		if (this.onInitalize) this.onInitalize(options);
	},
	
	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		if (this.onRender) this.onRender();
		return this;
	}
});