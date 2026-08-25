const express = require('express');
const router = express.Router();
const db = require('../database/db');

// GET /api/v1/config/:appId - Remote App & Ads Config (from Web Admin)
router.get('/:appId?', (req, res) => {
  const appId = req.params.appId || 'critter-camp';
  const config = db.getAppConfig(appId);

  res.json({
    success: true,
    data: config,
  });
});

// POST /api/v1/config/:appId - Admin Update Config
router.post('/:appId?', (req, res) => {
  const appId = req.params.appId || 'critter-camp';
  const updated = db.updateAppConfig(appId, req.body);

  res.json({
    success: true,
    message: 'App configuration updated successfully',
    data: updated,
  });
});

module.exports = router;
