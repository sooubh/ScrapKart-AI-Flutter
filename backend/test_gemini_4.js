const { GoogleGenerativeAI } = require('@google/generative-ai');

const apiKey = 'AIzaSyD49LbkJ0MbXYFxrin_PEPDcx48uSgxoaM';
const genAI = new GoogleGenerativeAI(apiKey);

async function testGemini() {
    try {
        console.log("Testing Gemini Flash Latest...");
        const model = genAI.getGenerativeModel({ model: "gemini-flash-latest" });
        const result = await model.generateContent("hello");
        console.log("Response:", result.response.text());
        console.log("✅ Gemini Flash Latest is Working!");
    } catch (error) {
        console.error("❌ Gemini Flash Latest Error:", error.message);
    }
}

testGemini();
