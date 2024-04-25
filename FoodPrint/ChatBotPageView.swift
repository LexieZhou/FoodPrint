//
//  ChatBotPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 15/10/2023.
//

import Foundation
import SwiftUI

struct ChatbotPageView: View {
    @State private var TOKEN: String = "" // DO NOT PUSH ONTO GITHUB
    @State private var messageText = ""
    @State private var recordText = ""
    @State private var records: [Record] = []
    @StateObject var allMessages = Messages()
    @State private var showSheet: Bool = false
    @State private var showNotification: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var notificationText: String = "Photo selected!"
    
    var body: some View {
        let _ = retrieveRecords()
        VStack{
            HStack{
                Text("ChatBot")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .bold()
                Image(systemName: "bubble.left.fill")
                    .foregroundColor(Color.blue)
            }
            ScrollView (){
                ForEach(allMessages.messages){ msg in
                    if (msg.message.contains("[USER]")) {
                        let newMessage = msg.message.replacingOccurrences(of: "[USER]", with: "")
                        HStack {
                            Spacer()
                            
                            if msg.photo == nil {
                                Text(newMessage)
                                    .padding()
                                    .foregroundColor(Color.black)
                                    .background(Color.blue.opacity(0.4))
                                    .cornerRadius(20)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 10)
                            }
                            else {
                                Image(uiImage: UIImage(data: msg.photo!)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(20)
                                    .frame(width: 100, height: 100)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 7)
                                    .padding(.bottom, 20)
                            }
                            
                        }
                    } else {
                        HStack {
                            Text(msg.message)
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
                        if messageText != "" {
                            allMessages.messages.append(Message(id: UUID(), message: "[USER]" + messageText))
                            allMessages.messages.append(Message(id: UUID(), message: getBotResponse(messages: allMessages.messages.map { $0.message })))
                            messageText = ""
                        }
                    }
                
                // send message button
                Button{
                    if messageText != "" {
                        allMessages.messages.append(Message(id: UUID(), message: "[USER]" + messageText))
                        // get GPT response
                        allMessages.messages.append(Message(id: UUID(), message: getBotResponse(messages: allMessages.messages.map { $0.message })))
                        messageText = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .font(.system(size: 26))
                .padding(.horizontal, 2)
                
                // select image button
                Button(action: {
                    self.showSheet = true
                }){
                    Image(systemName: "camera.fill")
                        .font(.system(size: 26))
                        .padding(.horizontal, 2)
                }
                .actionSheet(isPresented:$showSheet) {
                    ActionSheet(title: Text("Select Photo"),
                        message: Text("Take a photo to record your food"), buttons: [
                            .default(Text("Photo Library")) {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Camera")) {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
                }
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker, onDismiss:dismissImagePicker) {
            let _ = print(self.$showImagePicker)
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            
            }
        }
    
    func dismissImagePicker() {
        var base64String = ""
        if let imageData = image?.jpegData(compressionQuality: 0.1) {
            base64String = imageData.base64EncodedString()
        }
        if base64String != "" {
            // image is not nil
            if let imageData = image?.jpegData(compressionQuality: 0.1) {
                allMessages.writeMessage(id: UUID(), message: "[USER][IMG]"+base64String, photo: imageData)
            }
            allMessages.writeMessage(id: UUID(), message: getBotResponse(messages: allMessages.messages.map { $0.message }), photo: nil)
                    }
    }
    
    private func retrieveRecords() {
        FirebaseDataManager.retrieveRecords { records in
            self.records = records
            let timestamp = Array(records.map{$0.timestamp})
            let height = Array(records.map{$0.height})
            let weight = Array(records.map{$0.weight})
            let foodCategory = Array(records.map{$0.foodCategory})
            let calories = Array(records.map{$0.calories})
            recordText = ""
            if timestamp.count < 50 {
                for i in (0 ..< timestamp.count) {
                    recordText = recordText + "\(i), \(timestamp[i]), \(height[i]), \(weight[i]), \(foodCategory[i]), \(calories[i])\\n"
                }
            } else {
                for i in (0 ..< 20) {
                    recordText = recordText + "\(i), \(timestamp[i]), \(height[i]), \(weight[i]), \(foodCategory[i]), \(calories[i])\\n"
                }
                recordText = recordText + "...[PARTIAL DATA HIDDEN]...\\n"
                for i in (timestamp.count - 30 ..< timestamp.count) {
                    recordText = recordText + "\(i), \(timestamp[i]), \(height[i]), \(weight[i]), \(foodCategory[i]), \(calories[i])\\n"
                }
            }
        }
    }

    func getBotResponse(messages: [String]) -> String {
        retrieveRecords()
        let _ = print("last message:")
        let _ = print(messages[messages.count - 1].replacingOccurrences(of: "[USER]", with: ""))
        let _ = print("all message:")
        let _ = print(messages)
        var GPTResponse: String = "That's cool!"
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
            let payload = """
              {
                "model": "gpt-4-vision-preview",
                "max_tokens": 1000,
                "messages": [
                  {
                    "role": "system",
                    "content": "You are a helpful Personal Diet Assistant providing diet advice to help the user. Your answers need to be concise with no more than 50 words. The user is practicing 16:8 intermittent fasting, which involves an 8-hour window for food consumption and fasting for 16 hours. The 8-hour window starts upon the record of the first meal of the day. Please make use of the following user record to come up with personalized advice. The record is in comma-separated format and in chronological order.\\n record_id, timestamp, user_height, user_weight, food_eaten, kilogram_calories_of_food_eaten\\n\(self.recordText)\\nThe current timestamp is 20/11/2023 12:14."
                  },
                  \(messageThread(messages: messages))
                ]
              }
            """.data(using: .utf8) else{return "Error"}
    
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
                GPTResponse = String(str.components(separatedBy: "content\": \"")[1].components(separatedBy: "\"")[0])
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
                if messages[i].contains("[USER][IMG]"){
                    resArray.append("""
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": "Read the this photo."
                            },
                            {
                                "type": "image_url",
                                "image_url": {
                                    "url": "data:image/jpeg;base64,{\(messages[i].replacingOccurrences(of: "[USER][IMG]", with: ""))",
                                    "detail": "low"
                                }
                            }
                        ]
                    }
                    """)
                } else {
                    resArray.append("""
                  {
                    "role": "user",
                    "content": "\(messages[i].replacingOccurrences(of: "[USER]", with: ""))"
                  }
            """)
                }
                        } else {
                            resArray.append("""
                  {
                    "role": "assistant",
                    "content": "\(messages[i].replacingOccurrences(of: "\n", with: "\\n"))"
                  }
            """)
                        }
                    }
        resStr = resArray.joined(separator: ",\n")
        return resStr
    }

    func GPTResponseParser(GPTResponse: String) -> (String, Int?) {
        if GPTResponse.contains("@") {
            do {
                let food = try GPTResponse.components(separatedBy: "@")[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let cal = try Int(GPTResponse.components(separatedBy: "@")[1].replacingOccurrences(of: "kcal.", with: "").trimmingCharacters(in: .whitespacesAndNewlines))
                return (food, cal)
            } catch {
                return ("Unrecognized food", 0)
            }
        } else {
            return ("Unrecognized food", 0)
        }
    }
}

struct Message : Identifiable {
    var id : UUID
    var message: String
    var photo: Data?
}
class Messages : ObservableObject {
    @Published var messages : [Message] = []
    init() {
        messages.append(Message(id: UUID(), message: "Welcome to FoodPrint Personal Diet Assistant!"))
    }
    func writeMessage(id: UUID, message: String, photo: Data?) {
        let newMessage = Message(id: id, message: message, photo: photo)
        messages.append(newMessage)
    }
}
struct ChatbotPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotPageView()
    }
}
