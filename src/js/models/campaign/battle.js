Necro.Models.Campaign.Battle = Backbone.Model.extend({
	urlRoot: function() {
		return "/api/campaign/" + this.campaign_id + "/battle";
	},
	idAttribute: "id",
	defaults: {
		id: null,
		campaign_type_id: 0,
		campaign_territory_id: 0,
		rumble_date: new Date(),
		notes: null,
		battle_finalized: false,
		events: null,
		participants: null
	},
	
	parse: function(response) {
		if (response.rumble_date) response.rumble_date = new Date(response.rumble_date);
		if (response.battle_finalized) response.battle_finalized = true;
		
		if(response.territory) {
			response.territory = new Necro.Models.Campaign.Territory(response.territory);
		} else if (response.campaign_territory_id) {
			response.territory = new Necro.Models.Campaign.Territory({id: response.campaign_territory_id});
		}
		return response;
	}
	
});

Necro.Collections.Campaign.Battles = Backbone.Collection.extend({
	model: Necro.Models.Campaign.Battle,
	campaign_id: 0,
	url: function() {
		return "/api/campaign/" + this.campaign_id + "/battles";
	}
});

Necro.Models.Campaign.BattleParticipant = Necro.Models.Gang.extend({
	urlRoot: function() {
		return "/api/campaign/" + this.campaign_id + "/battle/" + this.battle_id + "/participant";
	},
	campaign_id: 0,
	battle_id: 0,
	idAttribute: "id",
	
	defaults: _.extend({
		winner: 0,
	}, Necro.Models.Gang.prototype.defaults)
});

Necro.Collections.Campaign.BattleParticipants = Backbone.Collection.extend({
	model: Necro.Models.Campaign.Battle,
	campaign_id: 0,
	battle_id: 0,
	url: function() {
		return "/api/campaign/" + this.campaign_id + "/battle/" + this.battle_id + "/participants";
	}
});

Necro.Models.Campaign.BattleEvent = Backbone.Model.extend({
	urlRoot: function() {
		return "/api/campaign/" + this.campaign_id + "/battle/" + this.battle_id + "/event";
	},
	campaign_id: 0,
	battle_id: 0,
	idAttribute: "id",
	defaults: {
		id: null,
		campaign_battle_id: 0,
		agressor_fighter_id: 0,
		victim_fighter_id: null,
		event_type_id: 0,
		die_roll: null,
		xp_val: null,
		created: new Date()
	},
	
	parse: function(response) {
		if (response.created) response.created = new Date(response.created);
		
		if (response.agressor_fighter) {
			response.agressor_fighter = new Necro.Models.Fighter(response.agressor_fighter);
		} else if (response.agressor_fighter_id) {
			response.agressor_fighter = new Necro.Models.Fighter({id: response.agressor_fighter_id});
		}
		
		if (response.victim_fighter) {
			response.victim_fighter = new Necro.Models.Fighter(response.victim_fighter);
		} else if (response.victim_fighter_id) {
			response.victim_fighter = new Necro.Models.Fighter({id: response.victim_fighter_id});
		}
		
		return response;
	}
});

Necro.Collections.Campaign.BattleEvents = Backbone.Collection.extend({
	model: Necro.Models.Campaign.BattleEvent,
	campaign_id: 0,
	battle_id: 0,
	url: function() {
		return "/api/campaign/" + this.campaign_id + "/battle/" + this.battle_id + "/events";
	}
});

Necro.Models.Campaign.EventType = Backbone.Model.extend({
	urlRoot: "/api/campaign/event-type",
	idAttribute: "id",
	defaults: {
		"id": null,
		"name": ""
	}
});

Necro.Collections.Campaign.EventTypes = Backbone.Collection.extend({
	model: Necro.Models.GangType,
	url: '/api/campaign/event-types',

	parse: function(resp) {
		this.add(resp);
		return resp;
	}
});
