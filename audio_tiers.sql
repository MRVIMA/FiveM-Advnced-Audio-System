-- Database table for vehicle upgrades
CREATE TABLE IF NOT EXISTS `vehicle_audio_tiers` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `player_id` VARCHAR(255) NOT NULL,
  `tier` VARCHAR(255) NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_player_id` (`player_id`),
  INDEX `idx_tier` (`tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample data for different tiers
INSERT INTO `vehicle_audio_tiers` (`player_id`, `tier`) VALUES 
('1', 'basic'),
('2', 'premium'),
('3', 'ultimate');

-- Additional indexes for better performance
CREATE INDEX idx_player_timestamp ON vehicle_audio_tiers(player_id, timestamp);