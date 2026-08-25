// Database Connection & In-Memory / SQLite persistence layer for Critter Camp Backend
const fs = require('fs');
const path = require('path');

class CritterDatabase {
  constructor() {
    this.players = new Map();
    this.stageProgress = new Map(); // key: `${playerId}:${stageNumber}`
    this.playerSettings = new Map();
    this.appConfigs = new Map();

    this.initDefaultData();
  }

  initDefaultData() {
    // Initial Web Admin Managed Config for 'critter-camp'
    this.appConfigs.set('critter-camp', {
      appId: 'critter-camp',
      appName: 'Critter Camp',
      adsEnabled: true,
      ads: {
        android: {
          appId: 'ca-app-pub-3940256099942544~3347511713',
          bannerId: 'ca-app-pub-3940256099942544/6300978111',
          interstitialId: 'ca-app-pub-3940256099942544/1033173712',
          rewardedId: 'ca-app-pub-3940256099942544/5224354917',
        },
        ios: {
          appId: 'ca-app-pub-3940256099942544~1458002511',
          bannerId: 'ca-app-pub-3940256099942544/2934735716',
          interstitialId: 'ca-app-pub-3940256099942544/4411468910',
          rewardedId: 'ca-app-pub-3940256099942544/1712485313',
        },
      },
      featureFlags: {
        zenModeEnabled: true,
        patternModeEnabled: true,
        cloudSyncEnabled: true,
      },
      maintenanceMode: false,
      minVersion: '1.0.0',
      updatedAt: new Date().toISOString(),
    });
  }

  // App Config
  getAppConfig(appId = 'critter-camp') {
    return this.appConfigs.get(appId) || this.appConfigs.get('critter-camp');
  }

  updateAppConfig(appId, configData) {
    const existing = this.getAppConfig(appId);
    const updated = {
      ...existing,
      ...configData,
      updatedAt: new Date().toISOString(),
    };
    this.appConfigs.set(appId, updated);
    return updated;
  }

  // Player Identity
  getOrCreatePlayer({ guestId, userId, email, displayName }) {
    // 1. Look up by userId (if authenticated)
    if (userId) {
      for (const player of this.players.values()) {
        if (player.userId === userId) {
          player.lastPlayedAt = new Date().toISOString();
          return player;
        }
      }
    }

    // 2. Look up by guestId
    if (guestId) {
      for (const player of this.players.values()) {
        if (player.guestId === guestId) {
          player.lastPlayedAt = new Date().toISOString();
          return player;
        }
      }
    }

    // 3. Create new Player
    const id = `player_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`;
    const newPlayer = {
      id,
      guestId: guestId || id,
      userId: userId || null,
      email: email || null,
      displayName: displayName || (userId ? 'CamperExplorer' : 'CozyCamper'),
      avatarEmoji: '🦊',
      isGuest: !userId,
      totalAcorns: 50,
      streakDays: 1,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      lastPlayedAt: new Date().toISOString(),
    };

    this.players.set(id, newPlayer);
    return newPlayer;
  }

  // Guest -> Account Upgrade (Safe Merge)
  upgradeGuestToAccount({ guestId, userId, email, displayName }) {
    let guestPlayer = null;
    let existingAuthPlayer = null;

    for (const p of this.players.values()) {
      if (p.guestId === guestId) guestPlayer = p;
      if (userId && p.userId === userId) existingAuthPlayer = p;
    }

    if (!guestPlayer && !existingAuthPlayer) {
      return this.getOrCreatePlayer({ guestId, userId, email, displayName });
    }

    // If existing auth player already exists, merge guest progress into it
    if (existingAuthPlayer && guestPlayer && existingAuthPlayer.id !== guestPlayer.id) {
      // Transfer stage progress from guest to existing account
      for (const [key, prog] of this.stageProgress.entries()) {
        if (prog.playerId === guestPlayer.id) {
          const authKey = `${existingAuthPlayer.id}:${prog.stageNumber}`;
          const existingProg = this.stageProgress.get(authKey);
          if (!existingProg) {
            this.stageProgress.set(authKey, { ...prog, playerId: existingAuthPlayer.id });
          } else {
            // Safe merge: MAX stars, MIN moves
            this.stageProgress.set(authKey, {
              ...existingProg,
              completed: existingProg.completed || prog.completed,
              stars: Math.max(existingProg.stars, prog.stars),
              bestMoves: Math.min(existingProg.bestMoves || 999, prog.bestMoves || 999),
              updatedAt: new Date().toISOString(),
            });
          }
        }
      }
      existingAuthPlayer.totalAcorns = Math.max(existingAuthPlayer.totalAcorns, guestPlayer.totalAcorns);
      this.players.delete(guestPlayer.id);
      return existingAuthPlayer;
    }

    // Otherwise simply attach userId to guest player
    const target = guestPlayer || existingAuthPlayer;
    target.userId = userId;
    target.email = email || target.email;
    target.displayName = displayName || target.displayName;
    target.isGuest = false;
    target.updatedAt = new Date().toISOString();
    return target;
  }

  // Stage Progress Sync (Safe Merge: completed OR, MAX stars, MIN moves)
  syncStageProgress(playerId, stagesToSync) {
    const results = [];

    for (const item of stagesToSync) {
      const key = `${playerId}:${item.stageNumber}`;
      const existing = this.stageProgress.get(key);

      if (!existing) {
        const newRecord = {
          id: key,
          playerId,
          stageNumber: item.stageNumber,
          completed: item.completed ?? true,
          stars: item.stars ?? 1,
          bestMoves: item.bestMoves ?? item.movesCount ?? 0,
          bestTimeSeconds: item.bestTimeSeconds ?? item.elapsedSeconds ?? 0,
          completedAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        };
        this.stageProgress.set(key, newRecord);
        results.push(newRecord);
      } else {
        // Safe Merge conflict resolution
        const merged = {
          ...existing,
          completed: existing.completed || item.completed,
          stars: Math.max(existing.stars, item.stars ?? 0),
          bestMoves: Math.min(existing.bestMoves || 999, item.bestMoves || item.movesCount || 999),
          bestTimeSeconds: Math.min(existing.bestTimeSeconds || 9999, item.bestTimeSeconds || item.elapsedSeconds || 9999),
          updatedAt: new Date().toISOString(),
        };
        this.stageProgress.set(key, merged);
        results.push(merged);
      }
    }

    return results;
  }

  getPlayerProgress(playerId) {
    const list = [];
    for (const prog of this.stageProgress.values()) {
      if (prog.playerId === playerId) {
        list.push(prog);
      }
    }
    return list;
  }
}

const db = new CritterDatabase();
module.exports = db;
