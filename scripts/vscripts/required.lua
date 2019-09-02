for _,file in ipairs({

    'libraries/timers',
    'libraries/utility',
    'libraries/animations',
    'libraries/popups',
    'libraries/attachments',
    'libraries/containers',
    'libraries/notifications',
    'libraries/physics',
--    'libraries/playertables',
    'libraries/projectiles',
    'libraries/sounds',
    'libraries/worldpanels',
--    'libraries/rangeactions',
	
	'utils/debug',
	'utils/util',

}) do
    --print("Requiring ", file)
    require(file)
end
