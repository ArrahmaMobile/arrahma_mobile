module.exports = {
  apps: [
    {
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
      error_file: './logs/api-err.log',
      out_file: './logs/api-out.log',
      log_file: './logs/api-combined.log',
      time: true,
      // Restart delay in case of crash
      restart_delay: 5000,
      // Maximum number of restart retries
      max_restarts: 10,
      // Minimum uptime before considered stable
      min_uptime: '10s',
      // Exponential backoff restart delay
      exp_backoff_restart_delay: 100
    },
    {
      name: 'arrahmah-scraper',
      script: 'dist/standalone-scraper.js',
      instances: 1,
      autorestart: false, // Don't auto-restart, it's a one-time run
      watch: false,
      cron_restart: '0 */2 * * *', // Run every 2 hours
      max_memory_restart: '1G', // Allow more memory for scraping
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/scraper-err.log',
      out_file: './logs/scraper-out.log',
      log_file: './logs/scraper-combined.log',
      time: true
    }
  ]
};
