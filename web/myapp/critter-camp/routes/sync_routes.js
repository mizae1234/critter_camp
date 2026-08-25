const express = require('express');
const router = express.Router();
const db = require('../database/db');

// GET /api/v1/sync/progress/:playerId - Pull cloud progress
router.get('/progress/:playerId', (req, res) => {
  const { playerId } = req.params;
  const progressList = db.getPlayerProgress(playerId);

  res.json({
    success: true,
    data: {
      playerId,
      stages: progressList,
    },
  });
});

// POST /api/v1/sync/progress - Batch Push Stage Progress (Safe Conflict Merge)
router.post('/progress', (req, res) => {
  const { playerId, stages } = req.body;

  if (!playerId || !Array.isArray(stages)) {
    return res.status(400).json({
      success: false,
      message: 'playerId and stages array are required',
    });
  }

  const syncedStages = db.syncStageProgress(playerId, stages);

  res.json({
    success: true,
    message: 'Progress synchronized and merged successfully',
    data: {
      playerId,
      syncedCount: syncedStages.length,
      stages: syncedStages,
    },
  });
});

module.exports = router;
