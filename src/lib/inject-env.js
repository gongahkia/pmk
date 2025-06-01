const fs = require('fs');
const path = require('path');
require('dotenv').config();

const templatePath = path.join(__dirname, '../app/app.js.template');
const outputPath = path.join(__dirname, '../app/app.js');

fs.readFile(templatePath, 'utf8', (err, data) => {
  if (err) throw err;
  const result = data
    .replace(/process\.env\.STRAVA_CLIENT_ID/g, `'${process.env.STRAVA_CLIENT_ID}'`)
    .replace(/process\.env\.STRAVA_CLIENT_SECRET/g, `'${process.env.STRAVA_CLIENT_SECRET}'`);
  fs.writeFile(outputPath, result, 'utf8', (err) => {
    if (err) throw err;
    console.log('Environment variables injected!');
  });
});