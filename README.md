# FoodPrint
## An AI-Powered Virtual Diet Assistant Mobile App
Introducing Foodprint – your virtual diet assistant who keeps track of everything you eat and provides you with the best customized advice before starting a new meal. 
## Motivation
Obesity is more than just a cosmetic concern. Today, one in every three adults is overweight, and one in every ten adults suffers from obesity (World Health Organization, 2022).
Inspired by the latest research conducted by Prof. Chair and her team at CUHK, Foodprint adopts the 16/8 intermittent fasting method, which has been examined to be one of the most effective approaches in alleviating overweight and reducing cardiometabolic risks (Chair et al., 2022). Foodprint employs this fasting approach with the firm objective of providing a healthy and doable solution for everyone in need of weight loss. 
While Foodprint is not the first product of its kind, we observe substantial limitations in the incumbent solutions employed by existing apps, namely cumbersome data-entry and superfluous functions, which discourage users from actually using them.


![ITEM NAMES (1)](https://github.com/LexieZhou/FoodPrint/assets/78584281/6630fa34-4a40-4379-a573-1bcab51aa78d)

## Tech Stacks
- Frontend: SwiftUI
- Backend: Firebase
- Chatbot integrates: OpenAI GPT-4

## Four main pages:

### Home Page
FoodPrint utilized an innovative way BATTERY to represent the elapsed time. When the user is in eating mode, the battery value goes down, representing the elapsed eating time. When the user is in fasting mode, the battery value goes up by charging, representing the elapsed fasting time.
Additionally, there are two convenient ways to record a meal. You can either take a photo, select a photo from the photo library, or manually input the food category and mass details. FoodPrint will then estimate the calories and store the records in our database.

### ChatBot Page
The ChatBot function inherent in FoodPrint is powered by GPT-4 and Firebase, which integrates user activities with the most cutting-edge AI chatbot to provide customized advice.  

### Record Page
The Record page consists of the diet calendar and WeightPrint chart. The diet calendar displays the success or failure of fasting tasks. Green dots indicate success, while red dots represent failure. You can easily slide the calendar to view your previous efforts. And you can tap on a specific date to access the meal records for that day. 
Additionally, the WeightPrint block evaluates user weight changes and helps users stay motivated.

### Profile Page
Moving to the profile page, you'll find the basic information you recorded during the sign-up process. From the Profile Page, you can easily edit your information or explore the streak rankings. Also, you may choose to log out back to the welcome page. 

## Reference
 - [FSCalendar](https://github.com/WenchaoD/FSCalendar)https://github.com/WenchaoD/FSCalendar 
 - [SwiftUIChart](https://github.com/willdale/SwiftUICharts)https://github.com/willdale/SwiftUICharts
