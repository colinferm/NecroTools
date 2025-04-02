Necro.Views.Modal = Backbone.View.extend({
	tagName: 'div',
	className: 'reveal',
	id: "fighterModal",
	templateName: 'modal-wrapper',

	events: {
		'click .action_save': 'saveData'
	},

	initialize : function(options) {
		this.opts = options;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.render();
	},

	render: function() {
		this.$el.html(this.template({modal_title: this.opts.title}));
		this.$el.attr('data-reveal', '');
		this.$el.attr('data-overlay', 'true');

		this.content = Necro.Utils.Resolver.getNewInstance(this.opts.class, {model: this.model});
		$('.modal-container', this.$el).html(this.content.render().$el);

		$('body').append(this.$el);

		var popup = new Foundation.Reveal(this.$el);
		//this.$el.on('closed.zf.reveal', _.bind(this.close, this));
		popup.open();

		return this.$el;
	},

	saveData: function() {
		this.content.save(_.bind(function(success, model) {
			if (success) {
				this.close();
				if (this.opts.callback) this.opts.callback(model);
			}
		}, this));
	},

	close: function(e) {
		console.log("Closing...");
		if (document.activeElement) {
			document.activeElement.blur();
		}
		this.$el.foundation('close');
		//$("#"+this.id).remove();
	}


});