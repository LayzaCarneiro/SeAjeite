# SeAjeite - Swift Student Challenge Winner

## Screenshots
### Personalized Routine & Positions
<p>
  <img src="https://github.com/user-attachments/assets/b652f878-4e26-4c91-8346-c58c851765ff" width="250"/>
  <img src="https://github.com/user-attachments/assets/7a2a59f7-ea3e-47ef-a3b7-48d5b493d93a" width="250"/>
</p>

### Guided Stretching Experience
<p>
  <img src="https://github.com/user-attachments/assets/6e6d2ed0-6384-4321-9824-e88997c261ac" width="250"/>
  <img src="https://github.com/user-attachments/assets/57065a83-1257-4c59-8164-d6a562941879" width="250"/>
</p>

### Smart Timer & Breathing Rhythm
<p>
  <img src="https://github.com/user-attachments/assets/665f9e68-b59d-4557-a3be-c3d8dc4db9d3" width="250"/>
  <img src="https://github.com/user-attachments/assets/d80b3133-c8c4-4401-bcbc-4123020d057d" width="250"/>
</p>

### Weekly Progress Tracking
<p>
  <img src="https://github.com/user-attachments/assets/8c1f19d6-b3c8-4347-bff3-d760b0a10c8b" width="250"/>
</p>


## Form Submitted

### What problem is your app playground trying to solve and what inspired you to solve it?

Many people suffer from chronic back pain and spinal conditions, such as scoliosis, often exacerbated by poor posture and long hours of sedentary work. While medical professionals recommend regular stretching and body awareness, the biggest challenge is consistency. It is difficult for users to remember to take breaks, track their weekly progress, or know which exercises are safe and effective for their current physical state (whether they are sitting at a desk or standing).
My inspiration is deeply personal. I grew up seeing how spinal health directly impacts quality of life. My mother has a history of scoliosis, and it broke my heart to see moments where she couldn't play with her grandchildren because of debilitating back pain. Recently, I was also diagnosed with similar issues, and through medical consultations, I discovered that regular stretching was the key to managing my pain—specifically a goal of 120 minutes per week. However, I struggled to stay disciplined and aware of my body throughout the busy day. I created "SeAjeite" to be the tool I wish I had: an intuitive, fluid, and encouraging companion that transforms a medical necessity into a mindful, rhythmic habit, helping others reclaim their mobility and peace.

### Who would benefit from your app playground and how?

"SeAjeite" is designed for anyone whose quality of life is compromised by sedentary habits or spinal conditions. Specifically, three groups would benefit most:

1. Individuals with Spinal Conditions: People like my mother and me, who manage conditions such as scoliosis, benefit from a tool that simplifies medical recommendations into actionable, timed stretching sessions. It transforms a daunting physical therapy routine into a series of achievable, daily "wins."
2. Remote Workers and Students: In an era of tech and long hours seated, this group often loses body awareness. The app helps them reintegrate movement into their routine—whether they have 2 minutes for a seated stretch between meetings or 10 minutes for a deeper floor session.
3. The Aging Population: As mobility naturally decreases, maintaining spinal flexibility is crucial. The app’s intuitive interface and visual breathing guides make it accessible for older users to maintain their independence and physical comfort.

It helps by combining visual charts with data-driven tracking, the app solves the "consistency gap." Users don't just stretch; they develop a rhythmic habit, visualize their progress toward clinical goals (like my personal 2-hour weekly target), and reclaim the ability to perform simple, joyful daily activities without pain.

### How did accessibility factor into your design process?

**Current Implementation:**
Accessibility was a core consideration from the first sketch of "SeAjeite." I focused on three main pillars:
1. **Visual Clarity & Symbols:** Instead of relying solely on text, I integrated **SF Symbols** across the app (like the position-specific icons) to provide clear visual cues for users with cognitive or situational disabilities.
2. **Color Contrast & Intent:** I used a high-contrast color palette with an **Action Color (AccentColor)** strategy. For the timer, I implemented a "traffic light" system (Green/Orange/Red) to communicate intensity and duration intuitively through color.
3. **Haptic Feedback:** To support users with low vision or those who aren't looking at the screen while stretching, I used **Haptics** (tactile feedback) to signal key moments, such as completing an exercise or starting the timer.

**Future Roadmap:**
I am committed to making the app even more inclusive. My next steps include:
- **VoiceOver Optimization:** Adding descriptive `accessibilityLabel` and `accessibilityHint` to the custom breathing animations and charts, ensuring that the progress visualization is meaningful for blind users.
- **Dynamic Type:** Fully supporting scalable text sizes so that users who require larger fonts can navigate the app without layout breaking, maintaining readability and comfort for all ages.

---

### What other technologies did you use in your app playground, and why did you choose them?

In addition to the core Swift language, I utilized the following native Apple technologies:

1. **SwiftUI:** I chose SwiftUI as the foundation of my app because its declarative nature allowed me to create a highly reactive and fluid user interface. Features like `withAnimation` and `symbolEffect` were essential to implement the "breathing" rhythm and the tactile feedback that my app's user experience requires.
2. **Swift Charts:** To solve the problem of tracking spinal health over time, I integrated Swift Charts. I chose this framework because it allowed me to transform raw stretching data into intuitive visual progress. This helps users stay motivated by seeing their consistency toward their weekly goals (like my 120-minute target) in a clear, accessible way.

---

## **Beyond the Swift Student Challenge**

Have you shared your app development knowledge with others or used your technology skills to support your community? Describe specific activities and impact. Note: This is about you, not your app.

---

## **Apps on the App Store (optional)**

**Phono - Improve Your Speech** 

Phono is an individual project I developed and published on the App Store to support individuals with speech disorders and communication challenges. The app provides a structured way to practice speech therapy exercises, helping users improve vocal clarity, pronunciation, and confidence in their daily interactions.
Developing Phono as an individual creator allowed me to manage the entire lifecycle—from UI/UX design in SwiftUI to audio implementation and App Store Connect submission. This project deeply influenced my approach to 'SeAjeite,' as both apps share the mission of using technology to provide autonomy and improve the quality of life for people facing physical or communication barriers. 

---

## **Social Media (optional)**

If you’d like to share links to your website or social media, please add them below.

## **Comments (optional)**

Is there anything else you‘d like us to know?

**Tools Used:** > I used **Gemini** (Google’s Large Language Model) as a coding and creative assistant, and ChatGPT (for visual conceptualization).

**Usage:**

1. **Visual Branding:** I used Gemini and ChatGPT to brainstorm and generate minimalist logo concepts. 
2. **Copywriting & Localization:** I used AI to refine the English descriptions of the app’s mission and to translate educational content.

**What I Learned:**

The most significant lesson was learning how to use AI as a conscious and honest collaborator. I realized that using AI effectively requires a high level of care and responsibility; it is a skill that takes time to understand. I had to learn how to move beyond simply generating code to critically analyzing every suggestion to ensure I truly understood the 'how' and 'why' behind it.

Working alone, I found AI to be an incredible brainstorming partner, but I learned that one must be careful not to let it replace personal logic. By avoiding the 'copy-paste' trap and instead using AI to explain complex concepts like SwiftUI state management or dynamic animations, I was able to optimize my time while actually deepening my technical knowledge. This journey taught me that AI is a powerful tool for an independent developer, provided it is used as a bridge to learning rather than a shortcut that bypasses it.

My journey in technology is driven by the belief that knowledge only grows when shared. I am deeply committed to my local ecosystem through three main pillars:

1. **Community Leadership:** I am an active member and organizer for **CocoaHeads Fortaleza**, one of the largest iOS developer communities in Brazil. I help organize dynamics, workshops, and technical talks, creating a welcoming space where both seasoned developers and beginners can exchange experiences about the Apple ecosystem.
2. **Social Impact:** I volunteer my technical skills for **"4 Patas,"** a local NGO dedicated to animal welfare. I am currently developing a mobile application to streamline the pet adoption process, using technology to connect abandoned animals with loving homes and helping the NGO manage their impact more efficiently.
3. **Academic Mentorship & Competitive Programming:** As a member of my university’s competitive programming study group, I mentor newcomers in algorithms and data structures. My dedication to coding excellence led me to become a **two-time finalist in the Latin American Women's Programming Contest (APPLE)**. This experience allows me to encourage other women in STEM, showing them that they belong in high-level technical spaces.

**Impact:** Through these activities, I don’t just write code; I build bridges. Whether it's helping a peer understand a complex sorting algorithm or building a platform for animal adoption, my goal is to use my Swift skills to empower my community and inspire the next generation of female developers in Ceará, Brazil.
