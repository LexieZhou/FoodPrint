//
//  ChatBotPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 15/10/2023.
//

import Foundation
import SwiftUI

struct ChatbotPageView: View {
    @State private var messageText = ""
    @State var messages: [String] = ["Welcome to Foodprint Personal Diet Assistant!"]
    
    func getBotResponse(message: String) -> String {
        let tempMsg = message.lowercased()
        
        // TODO: connect with API and modify bot return
        if (tempMsg.contains("hello")) {
            return "Hey there!"
        } else {
            return "That's cool!"
        }
    }
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                messages.append(getBotResponse(message: message))
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
                    .foregroundColor(Color.cyan)
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
                                .background(Color.cyan.opacity(0.5))
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
