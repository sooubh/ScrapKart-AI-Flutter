# ScrapKart AI - Diagram Image Generation Prompts

This file contains detailed prompts designed to be fed into AI image generation tools (like Midjourney, DALL-E 3, or Stable Diffusion) to create publication-quality UML and engineering diagrams for the ScrapKart AI project report.

**Global Style Instruction (Add to all prompts):**
> "Generate a clean, high-resolution, black-and-white, highly professional software engineering diagram suitable for an academic university project report. Use standard UML notation, crisp lines, white background, and clear, readable text blocks. Do not include unnecessary artistic flourishes or 3D effects. Keep the layout highly structured and logical."

---

### 1. System Architecture Diagram
**Prompt:**
> "A technical system architecture diagram for an AI-powered web platform called 'ScrapKart AI'. Show three distinct layers: A Presentation Layer containing 'Next.js Frontend (Customer, Collector, Admin UIs)'. An Application Layer in the middle containing 'Node.js Express Backend API' and a separate 'Python AI Microservice (YOLO/CNN Classification & Pricing Engine)'. A Data Layer at the bottom containing 'MongoDB Database'. Show bidirectional data flow arrows between the Frontend and Backend, and between the Backend, AI Microservice, and Database. Include external API integrations connecting to the Backend: 'Google Maps API' and 'Stripe Payment Gateway'. Ensure it looks like a clean, professional academic flow diagram."

### 2. Use Case Diagram
**Prompt:**
> "A professional UML Use Case diagram for a scrap recycling platform. Show three stick-figure actors on the outside: 'Customer', 'Collector', and 'Admin'. Inside a system boundary box titled 'ScrapKart AI', draw use case ovals. Customer connects to 'Register/Login', 'Upload Scrap Image', 'View Quote', 'Schedule Pickup'. Collector connects to 'View Assigned Pickups', 'View Optimized Route', 'Confirm Handover'. Admin connects to 'Manage Users', 'View Analytics'. Include an `<<include>>` relationship from 'Upload Scrap Image' to 'AI Scrap Classification'. Standard UML notation, clean black and white lines, white background."

### 3. Activity Diagram
**Prompt:**
> "A professional UML Activity diagram illustrating the workflow of an AI scrap valuation process. Start with a solid black circle (start node). Arrow down to 'User Uploads Image'. Arrow to 'Backend Receives Data'. Arrow to 'AI Microservice Processes Image'. Decision diamond: 'Scrap Identified?'. If No, arrow back to 'Request New Image'. If Yes, arrow down to 'Query Live Market Price'. Arrow down to 'Calculate Quote'. Arrow down to 'Display Quote to User'. Decision diamond: 'User Accepts?'. If Yes, 'Schedule Pickup'. If No, 'End Session'. End with a bulls-eye circle (final node). Clean, strict UML formatting."

### 4. Flowchart
**Prompt:**
> "A standard software engineering flowchart detailing the route optimization logic for a scrap collector. Start with an oval 'Start'. Process rectangle 'Fetch Accepted Pickups'. Database cylinder 'Retrieve Locations from MongoDB'. Process rectangle 'Send Coordinates to Google Maps API'. Process rectangle 'Generate Waypoint Matrix'. Process rectangle 'Apply Route Optimization Algorithm'. Output parallelogram 'Display Route on Collector Dashboard'. End oval 'End'. Use standard flowchart shapes, black and white, academic style."

### 5. Sequence Diagram
**Prompt:**
> "A professional UML Sequence diagram for a 'Scrap Valuation' process. Show four vertical lifelines at the top: 'Customer (Frontend)', 'Backend (Node.js)', 'AI Engine (Python)', and 'Database'. Time flows downwards. Message arrow from Customer to Backend: 'POST /upload-image'. Backend to AI Engine: 'Process Image'. AI Engine self-loop: 'Run YOLO Classification'. AI Engine returns to Backend: 'Material: Plastic, Volume: 2kg'. Backend to Database: 'Get Base Rate'. Database returns: 'Rate: $0.5/kg'. Backend self-loop: 'Calculate Total ($1.00)'. Backend returns to Customer: 'Display Quote: $1.00'. Clean, precise UML styling."

### 6. Class Diagram
**Prompt:**
> "A standard UML Class diagram for an e-commerce recycling platform. Include four main class boxes. 'User' class with attributes: ID, Name, Email, Role. 'Listing' class with attributes: ListingID, ImageURL, EstimatedWeight, QuotedPrice, Status. 'AIEngine' class with methods: `classifyImage()`, `estimateVolume()`. 'Transaction' class with attributes: TransactionID, FinalAmount, Timestamp. Show a 1-to-many relationship line from User to Listing, and 1-to-1 from Listing to Transaction. Draw it with clear compartments for class name, attributes, and methods."

### 7. Object Diagram
**Prompt:**
> "A UML Object diagram showing a specific instance in time for a system. Show an object box 'user1: Customer' linked to an object box 'listing104: Listing'. The 'listing104' box should list specific values: `status = "Pending"`, `material = "Cardboard"`, `quotedPrice = 5.50`. Link 'listing104' to 'collector5: Collector' showing the assignment. Standard UML object diagram formatting, underlined titles, clean aesthetic."

### 8. Collaboration Diagram (Communication Diagram)
**Prompt:**
> "A UML Collaboration diagram (Communication diagram) showing the interaction for confirming a pickup. Show actor 'Collector' sending message '1. confirmHandover()' to object 'BackendSystem'. 'BackendSystem' sends '2. updateStatus()' to 'Database'. 'BackendSystem' sends '3. initiateTransfer()' to 'PaymentGateway'. 'BackendSystem' sends '4. sendNotification()' to actor 'Customer'. Numbered arrows connecting the nodes. Clean, academic style."

### 9. State Diagram (State Machine)
**Prompt:**
> "A UML State Chart diagram for the lifecycle of a 'Scrap Listing' object. Start node arrow pointing to state box 'Pending Evaluation'. Arrow triggering 'AI Processed' leading to state 'Quoted'. Arrow triggering 'User Accepts' leading to state 'Scheduled'. Arrow triggering 'Collector Arrives' leading to state 'In Progress'. Arrow triggering 'Handover Confirmed' leading to state 'Completed'. Include an arrow from 'Quoted' to 'Cancelled' if 'User Rejects'. Strict UML state notation."

### 10. Component Diagram
**Prompt:**
> "A UML Component diagram for a microservices architecture. Show a large box 'Frontend Application' containing a 'React UI Component' symbol. Show a 'Backend API' component with a 'REST Interface' lollipop symbol. Show an 'AI Valuation Component' connecting to the Backend API. Show a 'MongoDB Database Component'. Show dependency dashed arrows connecting the Frontend to the Backend, and the Backend to both AI Component and Database. Black and white, formal engineering diagram."

### 11. Deployment Diagram
**Prompt:**
> "A UML Deployment diagram showing physical cloud architecture. Show a 3D box node labeled 'Client Device (Browser/Mobile)' connected via line 'HTTPS' to a cloud node labeled 'AWS Cloud Environment'. Inside the AWS cloud node, show a box node 'EC2 Instance (Web Server)' running 'Node.js/Next.js'. Show another box node 'GPU Instance' running 'Python AI Microservice'. Show a cylinder node 'MongoDB Atlas Cluster'. Draw communication lines between the EC2 instance, GPU instance, and Database. Professional, clean lines."

### 12. Entity-Relationship (ER) Diagram
**Prompt:**
> "A standard Entity-Relationship (ER) diagram for a database. Draw rectangular entity boxes: 'USERS', 'SCRAP_CATEGORIES', 'LISTINGS', 'TRANSACTIONS'. Use diamonds for relationships: 'creates' between USERS and LISTINGS, 'categorized_by' between LISTINGS and SCRAP_CATEGORIES, 'generates' between LISTINGS and TRANSACTIONS. Draw ovals attached to entities for attributes: 'UserID' (underlined), 'Role', 'PricePerKg', 'ListingID', 'TotalAmount'. Crow's foot notation for lines. Clean academic database design style."

### 13. Data Flow Diagram (DFD) Level 0 (Context Diagram)
**Prompt:**
> "A Level 0 Data Flow Diagram (Context Diagram) for 'ScrapKart AI System'. Draw a large central circle representing 'ScrapKart System'. Draw three external entity squares: 'Customer', 'Collector', 'Admin'. Draw curved arrows with labels showing data flow. Customer arrow to System labeled 'Scrap Image & Location'. System arrow to Customer labeled 'Price Quote & Receipt'. System arrow to Collector labeled 'Pickup Route Data'. Collector arrow to System labeled 'Confirmation'. Clean lines, black and white."

### 14. Data Flow Diagram (DFD) Level 1
**Prompt:**
> "A Level 1 Data Flow Diagram decomposing a system into processes. Draw four circular processes: '1.0 User Authentication', '2.0 Scrap Evaluation', '3.0 Logistics Management', '4.0 Transaction Processing'. Draw external entities 'Customer' and 'Collector'. Draw parallel lines representing data stores: 'D1 Users DB', 'D2 Listings DB', 'D3 Transactions DB'. Draw data flow arrows connecting the entities, processes, and data stores. Standard Gane-Sarson or Yourdon DFD notation, highly structured."

### 15. Data Flow Diagram (DFD) Level 2
**Prompt:**
> "A highly detailed Level 2 Data Flow Diagram focusing specifically on 'Process 2.0: Scrap Evaluation'. Draw sub-processes (circles): '2.1 Image Pre-processing', '2.2 Feature Extraction (CNN)', '2.3 Scrap Classification', '2.4 Price Calculation'. Draw data flow lines showing an 'Image Payload' entering 2.1, passing to 2.2, then to 2.3. Show 2.3 outputting 'Material ID' to 2.4. Show process 2.4 retrieving 'Base Rate' from a data store 'D4 Market Rates DB', and outputting 'Final Quote'. Clean, academic DFD styling."
