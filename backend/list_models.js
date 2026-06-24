const { GoogleGenerativeAI } = require('@google/generative-ai');

const apiKey = 'AIzaSyD49LbkJ0MbXYFxrin_PEPDcx48uSgxoaM';

async function listModels() {
    try {
        // We can't use SDK for listModels easily sometimes, let's use fetch/axios
        const axios = require('axios');
        const url = `https://generativelanguage.googleapis.com/v1beta/models?key=${apiKey}`;
        const response = await axios.get(url);
        console.log("Available Models:");
        response.data.models.forEach(m => {
            console.log(`- ${m.name} (supports: ${m.supportedGenerationMethods.join(', ')})`);
        });
    } catch (error) {
        console.error("❌ Error listing models:", error.response ? error.response.data : error.message);
    }
}

listModels();
