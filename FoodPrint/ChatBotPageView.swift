//
//  ChatBotPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 15/10/2023.
//

import Foundation
import SwiftUI

struct ChatbotPageView: View {
    @State private var TOKEN: String = "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" // DO NOT PUSH ONTO GITHUB
    
    @State private var messageText = ""
    @State private var recordText = ""
    @State private var records: [Record] = []
    @State var messages: [String] = ["Welcome to Foodprint Personal Diet Assistant!"]
    
    private func retrieveRecords() {
        FirebaseDataManager.retrieveRecords { records in
            self.records = records
            let timestamp = Array(records.map{$0.timestamp})
            let height = Array(records.map{$0.height})
            let weight = Array(records.map{$0.weight})
            let foodCategory = Array(records.map{$0.foodCategory})
            let calories = Array(records.map{$0.calories})
            recordText = ""
            if timestamp.count < 100 {
                for i in (0 ..< timestamp.count) {
                    recordText = recordText + "\(i), \(timestamp[i]), \(height[i]), \(weight[i]), \(foodCategory[i]), \(calories[i])\\n"
                }
            } else {
                for i in (0 ..< 20) {
                    recordText = recordText + "\(i), \(timestamp[i]), \(height[i]), \(weight[i]), \(foodCategory[i]), \(calories[i])\\n"
                }
                recordText = recordText + "...[PARTIAL DATA HIDDEN]...\\n"
                for i in (timestamp.count - 80 ..< timestamp.count) {
                    recordText = recordText + "\(i), \(timestamp[i]), \(height[i]), \(weight[i]), \(foodCategory[i]), \(calories[i])\\n"
                }
            }
        }
    }
    
    func getBotResponse(messages: [String]) -> String {
        retrieveRecords()
        var GPTResponse: String = "That's cool!"
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
            let payload = """
  {
    "model": "gpt-4-1106-preview",
    "temperature": 0.7,
    "max_tokens": 1000,
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful Personal Diet Assistant providing diet advices to help the user. Your answers need to be concise with no more than 50 words. The user is practicing 16:8 intermittent fasting, which involves an 8-hour window for food consumption and fasting for 16 hours. The 8-hour window starts upon the record of the first meal of the day. Please make use of the following user record to come up with personalized advice. The record is in comma-separated format and in chronological order.\\n record_id, timestamp, user_height, user_weight, food_eaten, kilogram_calories_of_food_eaten\\n\(self.recordText)\\nThe current timestamp is 20/11/2023 12:14."
      },
      \(messageThread(messages: messages))
    ]
  }
""".data(using: .utf8) else
        {
            return "Error"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(TOKEN)", forHTTPHeaderField: "Authorization")
        request.httpBody = payload
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { semaphore.signal() }
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
            if let str = String(data: data, encoding: .utf8) {
                print(str)
                GPTResponse = String(String(String(str.components(separatedBy: "\n")[10]).components(separatedBy: "\"content\": ")[1]).dropLast().dropFirst())
                print(GPTResponse)
            }
        }.resume()
        semaphore.wait()
        return GPTResponse.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    func messageThread(messages: [String]) -> String {
        var resStr: String = ""
        var resArray: [String] = []
        for i in (0 ..< messages.count) {
            if messages[i].contains("[USER]"){
                resArray.append("""
      {
        "role": "user",
        "content": "\(messages[i].replacingOccurrences(of: "[USER]", with: ""))"
      }
""")
            } else {
                resArray.append("""
      {
        "role": "assistant",
        "content": "\(messages[i])"
      }
""")
            }
        }
        resStr = resArray.joined(separator: ",\n")
        return resStr
    }
    
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                messages.append(getBotResponse(messages: messages))
            }
        }
    }
    
    var body: some View {
        let _ = retrieveRecords()
        VStack{
            HStack{
                Text("iBot")
                    .font(.custom("Kalam-Bold", size: 40))
                    .bold()
                Image(systemName: "bubble.left.fill")
                    .foregroundColor(Color.blue)
            }
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    if (message.contains("[USER]")) {
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        HStack {
                            Spacer()
                            Text(newMessage)
                                .padding()
                                .foregroundColor(Color.black)
                                .background(Color.blue.opacity(0.4))
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            
                        }
                    } else {
                        HStack {
                            Text(message)
                                .padding()
                                .foregroundColor(Color.black)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
                .background(Color.gray.opacity(0.05))
            
            HStack {
                TextField("Type Something ...", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .onSubmit {
                        sendMessage(message: messageText)
                    }
                Button{
                    sendMessage(message: messageText)
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }
            .padding()
        }
    }
}
struct ChatbotPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotPageView()
    }
}
