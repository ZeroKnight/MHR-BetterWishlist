-- NOTE: The nomenclature of "Category" in reference to WishList items/recipes
-- refers to those that require some amount of freely selectable parts that
-- belong to a *Category* of materials, e.g. 15 points of Anjanath parts.
-- Having enough of such parts for a wishlisted recipe is what triggers the
-- "Required material **types** gathered" message.

local tmo = sdk.to_managed_object
local fmt = string.format

local notifications_pruned = {
  last = 0,
  total = 0,
}

local WishListManager = setmetatable({}, {
  __index = function(self, key)
    if key == 'singleton' then
      rawset(self, 'singleton', sdk.get_managed_singleton 'snow.data.WishListManager')
      return rawget(self, 'singleton')
    elseif key == 'type' then
      rawset(self, 'type', sdk.find_type_definition 'snow.data.WishListManager')
      return rawget(self, 'type')
    end
  end,
})

local function get_WishInfoList()
  return tmo(tmo(WishListManager.singleton:get_field '_WishInfoListData'):get_field '_WishInfoList')
end

local function get_LogWishList()
  return tmo(tmo(WishListManager.singleton:get_field '_LogWishList'):get_field '_DispLogWishList')
end

local function post_initializeBeforeVillage(_)
  local seen = {}
  local has_category = {}
  local complete_wishlist_items = {}
  local wishinfolist = get_WishInfoList()
  local logwishlist = get_LogWishList()

  -- Determine which wishlist entries have category materials
  for i = 0, wishinfolist:get_Count() - 1 do
    local id = wishinfolist[i]:get_DataId()
    if id ~= 0 then
      -- snow.data.NormalItemData.MaterialCategory.None = 0
      local category = tmo(WishListManager.singleton:getWishDataCategory(i)):get_field '_Category'
      has_category[id] = category ~= 0
    end
  end

  -- Collect truly complete wishlist items, i.e. primary *and* possible category materials
  local orig_count = logwishlist:get_Count()
  for i = 0, orig_count - 1 do
    local wish = logwishlist[i]
    local id = wish:get_DataId()
    local isCategory = wish:isCategory()
    local wishdata = { wish = wish, idx = i }

    if not has_category[id] then
      -- Always add completed items with no category materials
      log.debug(fmt('Adding item with no category materials: %d', id))
      table.insert(complete_wishlist_items, wishdata)
    elseif seen[id] == nil then
      -- Potential completed item
      log.debug(fmt('Seen item %d (Category: %s)', id, tostring(isCategory)))
      seen[id] = wishdata
    else
      -- Found corresponding entry, add non-category half to the complete list
      log.debug(fmt('Found match for %d (Category: %s)', id, tostring(isCategory)))
      if isCategory then
        table.insert(complete_wishlist_items, seen[id])
      else
        table.insert(complete_wishlist_items, wishdata)
      end
    end
  end
  log.debug(fmt('Found %d complete wishlist items', #complete_wishlist_items))

  local pruned = orig_count - #complete_wishlist_items
  notifications_pruned.last = pruned
  notifications_pruned.total = notifications_pruned.total + pruned

  -- Rebuild LogWishList with only truly complete items
  logwishlist:Clear()
  for _, item in ipairs(complete_wishlist_items) do
    logwishlist:Add(item.wish)
  end
end

sdk.hook(WishListManager.type:get_method 'initializeBeforeVillage', function(_) end, post_initializeBeforeVillage)

re.on_draw_ui(function()
  if imgui.tree_node 'BetterWishlist' then
    if notifications_pruned.last > 0 then
      imgui.text(fmt('Pruned %d misleading wishlist notifications this visit. Nice!', notifications_pruned.last))
    else
      imgui.text 'No misleading wishlist notifications needed pruning this visit.'
    end
    imgui.text(fmt('Pruned %d notifications during this play session in total!', notifications_pruned.total))

    if imgui.tree_node 'Debug' then
      if imgui.button 'Spawn Wishlist Notifications' then
        log.debug 'Forcing wishlist notifications'
        log.debug 'initializeBeforeVillage'
        WishListManager.singleton:initializeBeforeVillage()
        log.debug 'wishListAnaunceVillage'
        WishListManager.singleton:wishListAnaunceVillage()
      end
      imgui.tree_pop() -- Debug
    end
    imgui.tree_pop() -- BetterWishlist
  end
end)

log.info 'BetterWishlist loaded. Enjoy!'
