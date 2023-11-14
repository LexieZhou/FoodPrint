//
//  ChatBotPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 15/10/2023.
//

import Foundation
import SwiftUI

struct ChatbotPageView: View {
    @State private var TOKEN: String = "" // DONOT PUSH ONTO GITHUB
    
    @State private var messageText = ""
    @State var messages: [String] = ["Welcome to Foodprint Personal Diet Assistant!"]
    
    func getBotResponse(messages: [String]) -> String {
        
        let tempMsg = messages.last!.replacingOccurrences(of: "[USER]", with: "")
        var GPTResponse: String = "That's cool!"
        
//        TODO: Change the content to include all historical messages
//        TODO: Modify the system message to make it a Diet Assistant
//        let _ = print(messages) // What's to be fed into GPT
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
            let payload = """
  {
    "model": "gpt-4-1106-preview",
    "temperature": 0.7,
    "max_tokens": 200,
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful Personal Diet Assistant providing diet advices to help the user. The user is currently practicing 16:8 intermittent fasting. It involves an 8-hour window for food consumption and fasting for 16 hours. Your answers need to be concise with no more than 50 words."
      },
      {
        "role": "user",
        "content": "\(tempMsg)"
      }
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
        return GPTResponse
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
