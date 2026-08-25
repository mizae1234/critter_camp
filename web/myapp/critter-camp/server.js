// Critter Camp Backend REST API Server (Zero-Dependency Pure Node.js)
const http = require('http');
const url = require('url');
const db = require('./database/db');
const { seedAdMob } = require('./database/seed_admob');

const PORT = process.env.PORT || 8097;

// Seed AdMob on server start
seedAdMob('development');

const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const path = parsedUrl.pathname.replace(/\/+$/, '');
  const method = req.method.toUpperCase();

  // CORS Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  res.setHeader('Content-Type', 'application/json');

  if (method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  // Parse Body
  let body = '';
  req.on('data', chunk => body += chunk);
  req.on('end', () => {
    let parsedBody = {};
    if (body) {
      try {
        parsedBody = JSON.parse(body);
      } catch (_) {}
    }

    handleRequest(req, res, method, path, parsedUrl.query, parsedBody);
  });
});

function handleRequest(req, res, method, path, query, body) {
  // 1. Health check
  if (method === 'GET' && (path === '/health' || path === '')) {
    return sendJson(res, 200, {
      status: 'ok',
      app: 'critter-camp-backend',
      platform: 'web/myapp',
      port: PORT,
      timestamp: new Date().toISOString(),
    });
  }

  // 2. GET /api/v1/config/critter-camp - Remote App & Ads Config
  if (method === 'GET' && path.startsWith('/api/v1/config')) {
    const parts = path.split('/');
    const appId = parts[4] || 'critter-camp';
    const config = db.getAppConfig(appId);
    return sendJson(res, 200, { success: true, data: config });
  }

  // 3. POST /api/v1/config/critter-camp - Admin Update Config
  if (method === 'POST' && path.startsWith('/api/v1/config')) {
    const parts = path.split('/');
    const appId = parts[4] || 'critter-camp';
    const updated = db.updateAppConfig(appId, body);
    return sendJson(res, 200, { success: true, message: 'Updated', data: updated });
  }

  // 4. POST /api/v1/players/identity - Get/Create Player
  if (method === 'POST' && path === '/api/v1/players/identity') {
    const player = db.getOrCreatePlayer(body);
    return sendJson(res, 200, { success: true, data: player });
  }

  // 5. POST /api/v1/players/upgrade - Guest -> Account Upgrade
  if (method === 'POST' && path === '/api/v1/players/upgrade') {
    const player = db.upgradeGuestToAccount(body);
    return sendJson(res, 200, { success: true, message: 'Account upgraded with all progress merged', data: player });
  }

  // 6. GET /api/v1/sync/progress/:playerId
  if (method === 'GET' && path.startsWith('/api/v1/sync/progress')) {
    const playerId = path.split('/')[5] || 'guest';
    const list = db.getPlayerProgress(playerId);
    return sendJson(res, 200, { success: true, data: { playerId, stages: list } });
  }

  // 7. POST /api/v1/sync/progress - Batch Cloud Sync
  if (method === 'POST' && path === '/api/v1/sync/progress') {
    const { playerId, stages } = body;
    if (!playerId || !Array.isArray(stages)) {
      return sendJson(res, 400, { success: false, message: 'playerId and stages array required' });
    }
    const synced = db.syncStageProgress(playerId, stages);
    return sendJson(res, 200, { success: true, data: { playerId, syncedCount: synced.length, stages: synced } });
  }

  // 404
  return sendJson(res, 404, { success: false, message: 'Endpoint not found', path });
}

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode);
  res.end(JSON.stringify(data, null, 2));
}

if (require.main === module) {
  server.listen(PORT, () => {
    console.log(`[Critter Camp Backend] Running natively on http://localhost:${PORT}`);
    console.log(`[Critter Camp Backend] Remote Config: http://localhost:${PORT}/api/v1/config/critter-camp`);
  });
}

module.exports = server;
