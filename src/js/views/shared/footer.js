Necro.Views.Footer = Backbone.View.extend({
	tagName: 'div',
	templateName: 'necro-footer',

	initialize : function(options) {
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = _.template(html);
	},

	render: function() {
		this.$el.append(this.template);
		return this.$el;
	}

});