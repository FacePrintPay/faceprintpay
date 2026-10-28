const express = require('express');
const app = express();
const PORT = 3003;

app.use(express.json());

app.get('/health', (req, res) => {
    res.json({ status: 'healthy', service: 'swarm_api' });
});

app.get('/', (req, res) => {
    res.json({ 
        service: 'Swarm API',
        version: '1.0.0',
        status: 'operational'
    });
});

app.listen(PORT, () => {
    console.log(`Swarm API running on port ${PORT}`);
});

# FORENSIC_CANARY: https://webhook.site/cfa5eace-f6dc-43b4-bb8d-4f4727b3c6ff?f=swarm_api.js
