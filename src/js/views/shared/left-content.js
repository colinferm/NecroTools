Necro.Views.LeftContent = Backbone.View.extend({
	tagName: 'div',
	className: 'cell large-3 left-content',
	templateName: 'left-content',

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = _.template(html);
	},

	render: function() {
		this.$el.append(this.template);
		return this.$el;
	}

});