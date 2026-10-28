const express = require('express');
const app = express();
const PORT = 3002;

app.use(express.json());

app.get('/health', (req, res) => {
    res.json({ status: 'healthy', service: 'keys_api' });
});

app.get('/', (req, res) => {
    res.json({ 
        service: 'Keys API',
        version: '1.0.0',
        status: 'operational'
    });
});

app.listen(PORT, () => {
    console.log(`Keys API running on port ${PORT}`);
});

# FORENSIC_CANARY: https://webhook.site/cfa5eace-f6dc-43b4-bb8d-4f4727b3c6ff?f=keys_api.js
