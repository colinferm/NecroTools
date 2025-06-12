Necro.Models.Campaign.CampaignType = Backbone.Model.extend({
	urlRoot: "/api/campaign-type",
	idAttribute: "id",
	defaults: {
		id: 0,
		name: '',
		next_in_series_id: null,
		combinable_id: null,
	},
	
	parse: function(response) {
		if (response.next_in_series) {
			response.next_in_series = new Necro.Models.Campaign.CampaignType(next_in_series);
		} else if (response.next_in_series_id) {
			response.next_in_series = new Necro.Models.Campaign.CampaignType({id: response.next_in_series_id});
		}
		if (response.combinable) {
			response.combinable = new Necro.Models.Campaign.CampaignType(response.combinable);
		} else if (response.combinable_id) {
			response.combinable = new Necro.Models.Campaign.CampaignType({id: response.combinable_id});
		}
		return response;
	}
});

Necro.Collections.Campaign.CampaignTypes = Backbone.Collection.extend({
	model: Necro.Models.Campaign.CampaignType,
	url: "/api/campaign-type"
});