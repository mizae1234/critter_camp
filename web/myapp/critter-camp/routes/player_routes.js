const express = require('express');
const router = express.Router();
const db = require('../database/db');

// POST /api/v1/players/identity - Get or Create Guest / User Identity
router.post('/identity', (req, res) => {
  const { guestId, userId, email, displayName } = req.body;
  const player = db.getOrCreatePlayer({ guestId, userId, email, displayName });

  res.json({
    success: true,
    data: player,
  });
});

// POST /api/v1/players/upgrade - Upgrade Guest to Authenticated Account (Safe Merge)
router.post('/upgrade', (req, res) => {
  const { guestId, userId, email, displayName } = req.body;

  if (!guestId || !userId) {
    return res.status(400).json({
      success: false,
      message: 'guestId and userId are required for account upgrade',
    });
  }

  const upgradedPlayer = db.upgradeGuestToAccount({ guestId, userId, email, displayName });

  res.json({
    success: true,
    message: 'Account upgraded successfully with all progress preserved',
    data: upgradedPlayer,
  });
});

module.exports = router;
