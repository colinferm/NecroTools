Necro.Views.Modal = Backbone.View.extend({
	tagName: 'div',
	className: 'modal',
	templateName: 'modal-wrapper',
	modalSize: null,

	events: {
		'click .action_save': 'saveData',
		'keypress': 'keyAction'
	},

	initialize : function(options) {
		this.opts = options;
		this.modalSize = options.modalSize;
		var html = Necro.Utils.UI.TPL.get(this.templateName);
		this.template = Handlebars.compile(html);
		this.render();
	},

	render: function() {
		this.$el.html(this.template({modal_title: this.opts.title}));
		if (this.modalSize) $('.modal-dialog', this.$el).addClass(this.modalSize);

		this.content = Necro.Utils.Resolver.getNewInstance(this.opts.class, {model: this.model});
		this.content.options = this.opts;
		
		$('.modal-body', this.$el).html(this.content.render().$el);
		$('body').append(this.$el);


		this.modal = new bootstrap.Modal(this.el);
		this.$el.on('hidden.bs.modal', _.bind(this.removeSelf, this))
		this.modal.show();

		return this.$el;
	},

	keyAction: function(e) {
		//console.log(e.keyCode);
		if (e.keyCode === 27) {
			this.removeSelf();
		}
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
		this.removeSelf();
	},

	removeSelf: function() {
		this.modal.hide();
		this.$el.remove();
	}


});