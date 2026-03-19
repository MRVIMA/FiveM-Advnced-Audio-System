CREATE TABLE IF NOT EXISTS `vehicle_audio_tiers` (
  `plate` VARCHAR(50) NOT NULL,
  `tier` VARCHAR(50) NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



/* Next Steps for Implementation
To finish the QBCore/Jim-Mechanic integration, you will need to add the physical items to your qb-core/shared/items.lua file so players can hold them in their inventory.

['audio_standard'] 	= {['name'] = 'audio_standard', 	['label'] = 'Standard Audio System', 	['weight'] = 5000, 	['type'] = 'item', 	['image'] = 'amplifier.png', 	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'An aftermarket car audio upgrade.'},
['audio_premium'] 	= {['name'] = 'audio_premium', 		['label'] = 'Premium Audio System', 	['weight'] = 6000, 	['type'] = 'item', 	['image'] = 'subwoofer.png', 	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A high-end car audio setup.'},
['audio_ultimate'] 	= {['name'] = 'audio_ultimate', 	['label'] = 'VoidVima Ultimate Setup', 	['weight'] = 8000, 	['type'] = 'item', 	['image'] = 'sound_system.png', ['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'The absolute loudest, glass-shattering phonk machine setup available.'},
*/
