function getSkinPropIdentifiers(prop)
	local first_identifier, second_identifier = prop .. '_1', prop .. '_2'
	if prop == 'arms' then first_identifier = prop end
	return {first = first_identifier, second= second_identifier}
end

function isSkinFree(skin, currentSkin)
	if skin == 'torso_1' 	and currentSkin[skin] == 15 then return true end
	if skin == 'tshirt_1' 	and currentSkin[skin] == 15 then return true end
	if skin == 'shoes_1' 	and currentSkin[skin] == 34 then return true end
	if skin == 'arms'		and currentSkin[skin] < 16 	then return true end
	if skin == 'chain_1' 	and currentSkin[skin] == 0 	then return true end
	if skin == 'helmet_1' 	and currentSkin[skin] == -1 then return true end
	if skin == 'glasses_1' 	and currentSkin[skin] == 0 	then return true end
	if skin == 'watches_1' 	and currentSkin[skin] == -1 then return true end
	if skin == 'bags' 		and currentSkin[skin] == 0 	then return true end
	return false
end

function isSkinOwned(identifier, skinProp, currentSkin)
	local owned = false
	local ids = getSkinPropIdentifiers(skinProp)

	TriggerEvent('esx_datastore:getDataStore', 'user_clothes', identifier, function(store)
		local owned_clothes = store.get('owned_clothes') or {}
		owned = owned_clothes[skinProp .. '_' .. currentSkin[ids.first] .. '_' .. currentSkin[ids.second]]
	end)

	return owned
end

function changedSkin(skinProp, newSkin, oldSkin)
	local ids = getSkinPropIdentifiers(skinProp)
	return (newSkin[ids.first] ~= oldSkin[ids.first]) or (newSkin[ids.second] ~= oldSkin[ids.second])
end

function shouldCharge(xPlayer, value, newSkin)
	return (not isSkinFree(value, newSkin) and not isSkinOwned(xPlayer.identifier, value, newSkin))
end