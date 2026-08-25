-- Critter Camp Production Database Schema
-- Part of the Shared Platform (web/myapp)

CREATE TABLE IF NOT EXISTS app_configs (
    app_id VARCHAR(64) PRIMARY KEY,
    app_name VARCHAR(128) NOT NULL,
    ads_enabled BOOLEAN DEFAULT TRUE,
    android_app_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544~3347511713',
    android_banner_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544/6300978111',
    android_interstitial_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544/1033173712',
    android_rewarded_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544/5224354917',
    ios_app_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544~1458002511',
    ios_banner_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544/2934735716',
    ios_interstitial_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544/4411468910',
    ios_rewarded_id VARCHAR(128) DEFAULT 'ca-app-pub-3940256099942544/1712485313',
    maintenance_mode BOOLEAN DEFAULT FALSE,
    min_version VARCHAR(32) DEFAULT '1.0.0',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS players (
    id VARCHAR(64) PRIMARY KEY,
    guest_id VARCHAR(64) UNIQUE,
    user_id VARCHAR(64) UNIQUE,
    email VARCHAR(255),
    display_name VARCHAR(128) NOT NULL DEFAULT 'CozyCamper',
    avatar_emoji VARCHAR(16) DEFAULT '🦊',
    is_guest BOOLEAN DEFAULT TRUE,
    total_acorns INT DEFAULT 50,
    streak_days INT DEFAULT 1,
    country_code VARCHAR(8) DEFAULT 'TH',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stage_progress (
    id VARCHAR(128) PRIMARY KEY, -- player_id:stage_number
    player_id VARCHAR(64) NOT NULL,
    stage_number INT NOT NULL,
    completed BOOLEAN DEFAULT TRUE,
    stars INT DEFAULT 1,
    best_moves INT DEFAULT 0,
    best_time_seconds INT DEFAULT 0,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS player_settings (
    player_id VARCHAR(64) PRIMARY KEY,
    zen_mode BOOLEAN DEFAULT FALSE,
    pattern_mode BOOLEAN DEFAULT FALSE,
    music_volume FLOAT DEFAULT 0.8,
    sfx_volume FLOAT DEFAULT 1.0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
);

-- Seed initial App Config for critter-camp
INSERT OR REPLACE INTO app_configs (
    app_id, app_name, ads_enabled,
    android_app_id, android_banner_id, android_interstitial_id, android_rewarded_id,
    ios_app_id, ios_banner_id, ios_interstitial_id, ios_rewarded_id,
    maintenance_mode, min_version
) VALUES (
    'critter-camp', 'Critter Camp', TRUE,
    'ca-app-pub-3940256099942544~3347511713', 'ca-app-pub-3940256099942544/6300978111',
    'ca-app-pub-3940256099942544/1033173712', 'ca-app-pub-3940256099942544/5224354917',
    'ca-app-pub-3940256099942544~1458002511', 'ca-app-pub-3940256099942544/2934735716',
    'ca-app-pub-3940256099942544/4411468910', 'ca-app-pub-3940256099942544/1712485313',
    FALSE, '1.0.0'
);
