module.exports = {
  apps: [{
    name: 'arrahmah-api',
    script: 'dist/api/server.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '500M',
    env: {
      NODE_ENV: 'production',
      PORT: 8888
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true,
    // Restart delay in case of crash
    restart_delay: 5000,
    // Maximum number of restart retries
    max_restarts: 10,
    // Minimum uptime before considered stable
    min_uptime: '10s',
    // Exponential backoff restart delay
    exp_backoff_restart_delay: 100
  }]
};
