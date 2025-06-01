const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const TEMPLATE_PATH = path.join(__dirname, '../app/app.js.template');
const OUTPUT_PATH = path.join(__dirname, '../app/pebble-js-app.js');

const requiredVars = ['STRAVA_CLIENT_ID', 'STRAVA_CLIENT_SECRET'];
requiredVars.forEach(varName => {
  if (!process.env[varName]) {
    throw new Error(`Missing required environment variable: ${varName}`);
  }
});

fs.readFile(TEMPLATE_PATH, 'utf8', (err, template) => {
  if (err) {
    console.error('Error reading template file:', err);
    process.exit(1);
  }
  const injected = template
    .replace(/process\.env\.STRAVA_CLIENT_ID/g, `'${process.env.STRAVA_CLIENT_ID}'`)
    .replace(/process\.env\.STRAVA_CLIENT_SECRET/g, `'${process.env.STRAVA_CLIENT_SECRET}'`);
  fs.writeFile(OUTPUT_PATH, injected, 'utf8', err => {
    if (err) {
      console.error('Error writing generated file:', err);
      process.exit(1);
    }
    console.log(`Successfully generated ${path.relative(process.cwd(), OUTPUT_PATH)}`);
  });
});