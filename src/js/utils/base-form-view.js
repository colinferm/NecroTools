Necro.Views.ValidationView = Backbone.View.extend({
	events: {
		'change .form-control': 'validate',
		'focusout .form-control': 'validate',
		'click .form-check-input': 'validate'
	},
	
	validate: function(e) {
		let field = $(e.currentTarget);
		if (this.checkValidation) this.checkValidation(field);
		if ($('.is-invalid', this.$el).length == 0) {
			$('.validation-alert', this.el).removeClass('d-block').addClass('d-none');
		}
	},

	validateInfo: function(item, cb) {
		console.log(item);

		$.ajax({
			url: '/api/registerValidation',
			data: item,
			dataType: 'json',
			method: 'POST',
			success: _.bind(function(data) {
				cb(true);
			}, this),
			error: _.bind(function(data) {
				cb((data.status == 200));
			}, this),
		});
	},

	doSave: function(callback) {
		if ($('.is-invalid', this.$el).length) {
			$('.validation-alert', this.el).addClass('d-block').removeClass('d-none');
			return;
		}
		if (this.save) this.save(callback);
	}
});