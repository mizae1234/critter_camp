const express = require('express');
const app = express();
const PORT = process.env.PORT || 8097;

app.use(express.json());

// CORS for local development and web clients
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    app: 'critter-camp-backend',
    platform: 'web/myapp',
    timestamp: new Date().toISOString(),
  });
});

// API Routes
app.use('/api/v1/config', require('./routes/config_routes'));
app.use('/api/v1/players', require('./routes/player_routes'));
app.use('/api/v1/sync', require('./routes/sync_routes'));

// Start server
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`[Critter Camp Backend] Running on http://localhost:${PORT}`);
    console.log(`[Critter Camp Backend] Remote Config: http://localhost:${PORT}/api/v1/config/critter-camp`);
  });
}

module.exports = app;
