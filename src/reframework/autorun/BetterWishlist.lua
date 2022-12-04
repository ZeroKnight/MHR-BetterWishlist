-- NOTE: The nomenclature of "Category" in reference to WishList items/recipes
-- refers to those that require some amount of freely selectable parts that
-- belong to a *Category* of materials, e.g. 15 points of Anjanath parts.
-- Having enough of such parts for a wishlisted recipe is what triggers the
-- "Required material **types** gathered" message.

local WishListManagerType = sdk.find_type_definition 'snow.data.WishListManager'

-- Skipping this method only prevents the "material type gathereds" message,
-- but not the "materials gathered" message, which is what we want.
sdk.hook(WishListManagerType:get_method 'checkWishListCategoryCompleteVillage', function(_)
  return sdk.PreHookResult.SKIP_ORIGINAL
end, function(_) end)
