RegisterServerEvent('esx_clotheshop:saveOutfit')
AddEventHandler('esx_clotheshop:saveOutfit', function(label, skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
		store.save()
	end)
end)

ESX.RegisterServerCallback('esx_clotheshop:buyClothes', function(source, cb, newSkin, oldSkin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local purchaseCost = 0
	local acquiredPieces = {}

	if(Config.ChargePerPiece) then
		for key,value in pairs(Config.SkinProps) do
			if (changedSkin(value, newSkin, oldSkin)) and shouldCharge(xPlayer, value, newSkin) then
				local ids = getSkinPropIdentifiers(value)
				acquiredPieces[value .. '_' .. newSkin[ids.first] .. '_' .. newSkin[ids.second]] = true
				purchaseCost = purchaseCost + Config.Price
			end
		end
	else
		purchaseCost = Config.Price
	end

	if xPlayer.getMoney() >= purchaseCost then
		xPlayer.removeMoney(purchaseCost, "Outfit Purchase")
		TriggerEvent('esx_datastore:getDataStore', 'user_clothes', xPlayer.identifier, function(store)
			local clothes = store.get('owned_clothes') or {}
			for key, value in pairs(acquiredPieces) do clothes[key] = value end
			store.set('owned_clothes', clothes)
			store.save()
		end)
		TriggerClientEvent('esx:showNotification', source, TranslateCap('you_paid', purchaseCost))
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundStore = false

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)
