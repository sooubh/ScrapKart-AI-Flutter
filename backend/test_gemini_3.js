const { GoogleGenerativeAI } = require('@google/generative-ai');

const apiKey = 'AIzaSyD49LbkJ0MbXYFxrin_PEPDcx48uSgxoaM';
const genAI = new GoogleGenerativeAI(apiKey);

async function testGemini() {
    try {
        console.log("Testing Gemini Pro...");
        const model = genAI.getGenerativeModel({ model: "gemini-pro" });
        const result = await model.generateContent("hello");
        console.log("Response:", result.response.text());
        console.log("✅ Gemini Pro is Working!");
    } catch (error) {
        console.error("❌ Gemini Pro Error:", error.message);
    }
}

testGemini();
