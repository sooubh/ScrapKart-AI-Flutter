const { GoogleGenerativeAI } = require('@google/generative-ai');

const apiKey = 'AIzaSyD49LbkJ0MbXYFxrin_PEPDcx48uSgxoaM';
const genAI = new GoogleGenerativeAI(apiKey);

async function listModels() {
    try {
        console.log("Listing available models...");
        // In newer versions, we use genAI.listModels() if available or similar.
        // But let's just try to hit 'gemini-1.5-flash-8b' or 'gemini-1.5-pro'
        const modelNames = ["gemini-1.5-flash", "gemini-1.5-flash-latest", "gemini-pro", "gemini-1.5-pro"];
        
        for (const name of modelNames) {
            try {
                const model = genAI.getGenerativeModel({ model: name });
                const result = await model.generateContent("test");
                console.log(`✅ Model ${name} is available!`);
                return;
            } catch (e) {
                console.log(`❌ Model ${name} failed: ${e.message}`);
            }
        }
    } catch (error) {
        console.error("❌ Error:", error.message);
    }
}

listModels();
