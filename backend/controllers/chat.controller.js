const { GoogleGenerativeAI } = require('@google/generative-ai');

// Setting up access to Gemini 1.5 using provided Key
const apiKey = process.env.GEMINI_API_KEY || 'AIzaSyD49LbkJ0MbXYFxrin_PEPDcx48uSgxoaM';
const genAI = new GoogleGenerativeAI(apiKey);

// Explicit prompt mapping the AI tightly strictly to Scrap/Recycling inquiries over casual banter
const baseSystemInstruction = `You are an assistant for ScrapKart. Only answer questions related to recycling, scrap rates, scrap details, and material donations. Do not answer outside queries. If a user asks something unrelated, kindly decline and steer them back to recycling topics. Keep your answers concise, engaging, and friendly.`;

// Simple Knowledge Base for RAG (Retrieval-Augmented Generation)
const knowledgeBase = [
    { keywords: ["plastic", "pet", "bottle", "polyethylene"], content: "Plastic bottles (PET) usually fetch about ₹12 - ₹15 per kg. Ensure they are crushed and cleaned. Hard plastics like containers can reach ₹20/kg." },
    { keywords: ["metal", "iron", "steel", "copper", "aluminum", "brass"], content: "Metals yield high returns. Copper is premium (₹400+/kg). Aluminum cans fetch ₹70-90/kg. Iron is stable at ₹25-30/kg. Separate them for more cash!" },
    { keywords: ["paper", "cardboard", "newspaper", "magazine"], content: "Cardboard and office paper are ₹12 - ₹15 per kg. Old newspapers are around ₹10/kg. Keep them bundled and dry to avoid weight rejection." },
    { keywords: ["electronics", "e-waste", "tv", "phone", "laptop", "battery"], content: "E-waste circuit boards are valuable! We pay ₹50-150 for old phones and ₹200 for laptops. Lead-acid batteries from cars fetch ₹60/kg." },
    { keywords: ["donate", "donation", "clothes", "toys", "ngo", "help"], content: "ScrapKart's Donation module allows you to give away old clothes, toys, and usable books. These are collected for free and delivered to our partner NGOs like Goonj and local orphanages." },
    { keywords: ["book", "booking", "schedule", "pickup", "appointment"], content: "Bookings are easiest via the 'Schedule Pickup' button on the home screen. You'll get a real-time tracking link and a collector will call you 10 mins before arrival." },
    { keywords: ["rate", "price", "prediction", "cost"], content: "Our AI Prediction uses Gemini Vision to estimate prices based on material purity and current Nashik market trends. Check the 'Price Predictions' section for daily updates." }
];

function retrieveContext(message) {
    const query = message.toLowerCase();
    let retrievedContext = "";
    
    for (const doc of knowledgeBase) {
        // If any keyword matches the query, append the knowledge
        if (doc.keywords.some(kw => query.includes(kw))) {
            retrievedContext += `- ${doc.content}\n`;
        }
    }
    return retrievedContext;
}

exports.chat = async (req, res) => {
    try {
        const { message } = req.body;
        
        if (!message) {
            return res.status(400).json({ success: false, reply: "Message cannot be empty." });
        }

        // Simulate processing delay
        await new Promise(resolve => setTimeout(resolve, 1000));

        // RAG Implementation: Retrieve relevant facts from local knowledge base only
        const retrievedData = retrieveContext(message);
        
        let reply = "";
        if (retrievedData.length > 0) {
            reply = `Based on ScrapKart knowledge:\n${retrievedData}\nIs there anything else I can help you with regarding these materials?`;
        } else {
            reply = "I'm the ScrapKart Assistant! I can help you with recycling tips, scrap rates, and material classification. Could you please specify which material you are interested in (e.g., Plastic, Metal, Paper)?";
        }

        return res.status(200).json({
            success: true,
            reply: reply
        });

    } catch (error) {
        console.error("Dummy Chat Engine Error:", error);
        return res.status(500).json({ success: false, reply: "I'm currently undergoing offline maintenance, but I'll be back shortly." });
    }
};
