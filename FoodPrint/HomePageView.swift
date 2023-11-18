//
//  HomePageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI
import Firebase

struct HomePageView: View {
    @State private var TOKEN: String = "" // DONOT PUSH ONTO GITHUB
    
    @State var progress = 0.5
    @State private var showAlert = false
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showingAddRecord = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    @State private var showNotification: Bool = false
    @State private var notificationText: String = "Photo selected!"
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                if showNotification {
                    BannerNotification(text: notificationText, color: notificationText == "No photo selected." ? .red : .green, showNotification: $showNotification)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut)
                        .offset(x:0, y: -350)
                }
                
                VStack(spacing: 5) {
                    
                    VStack(spacing: 10) {
                        if vm.isActive {
                            if vm.isEating {
                                Text("Eating Time!")
                                    .padding(.vertical, 8)
                                    .font(.custom("Kalam-Bold", size: 35))
                                    .opacity(0.7)
                            } else {
                                Text("You are fasting now!")
                                    .padding(.vertical, 8)
                                    .font(.custom("Kalam-Bold", size: 35))
                                    .opacity(0.7)
                            }
                        } else {
                            //MARK: start eating button
                            Button("Tap here to start!"){
                                print("touch start eating button")
                                vm.startEating(eatingTime: vm.eatingTime)
                            }.font(.custom("Kalam-Bold", size: 35))
                        }
                        
                        
                        
                        HStack(spacing: 5) {
                            Text(vm.initialTime, format: .dateTime.weekday().hour().minute()).font(.custom("Kalam-Bold", size: 20))
                            
                            if vm.isActive {
                                Text("->")
                                    .fontWeight(.bold).font(.custom("Kalam-Bold", size: 25))
                                
                                Text(vm.endDate, format: .dateTime.weekday().hour().minute()).fontWeight(.bold).font(.custom("Kalam-Regular", size: 20))
                            }
                        }
                        
                    }
                    
                    VStack(spacing: 5) {
                        
                        ZStack {
                            //MARK: battery
                            vm.batteryImg
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 150)
                                .offset(CGSize(width: 8.0, height: 10.0))
                            
                            //MARK: ligntning
                            if vm.isEating == false && vm.isActive {
                                Image("lightning")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50, height:50)
                                    .offset(x:0, y:15)
                                
                                
                            }
                        }
                        
                        
                        //MARK: remaining time
                        Text("\(vm.time)")
                            .font(.custom("Kalam-Bold", size: 20))
                            .alert("Timer done!", isPresented: $vm.showingAlert) {
                                Button("Continue") {
                                    // Wrap the action in a DispatchQueue.main.asyncAfter block
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        if vm.isEating {
                                            vm.startFasting(fastingTime: vm.fastingTime)
                                        } else {
                                            vm.startEating(eatingTime: vm.eatingTime)
                                        }
                                    }
                                }
                            }
                        
                        
                        //MARK: stop early button
                        if vm.isActive {
                            Button("Stop Early") {
                                // Action to perform when the button is tapped
                                showAlert = true
                            }
                            .font(.custom("Kalam-Bold", size: 20))
                            .foregroundColor(.white)
                            .padding(.all, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .offset(x: 0, y: 10)
                            .tint(.red)
                            .alert(vm.isEating ? "Are you sure you don't want to eat any more?😎" : "If you give up, you will fail today😭...Remember to switch back to fasting after your little treat!", isPresented: $showAlert) {
                                Button("Yes", action: vm.stopEarly)
                                Button("Cancel", role: .cancel) {
                                    vm.showingAlert = false
                                }
                            }
                        }
                        
                        //MARK: camera
                        if vm.isActive && vm.isEating {
                            VStack {
                                Button(action: {
                                    self.showSheet = true
                                }) {
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(.blue)
                                        .padding(.bottom, 5)
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
                                
                                Button(action: {
                                    showingAddRecord.toggle()
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 65, height: 65)
                                        .foregroundColor(.blue)
                                }.sheet(isPresented: $showingAddRecord) {
                                    AddRecordSheet(isPresented: $showingAddRecord)
                                }
                            }.offset(x: 125, y: 50)
                        } else if vm.isActive && !vm.isEating{
                            VStack { 
                                Image(systemName: "camera.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 65, height: 65)
                                    .foregroundColor(Color(#colorLiteral(red: 0.6356717139, green: 0.6356717139, blue: 0.6356717139, alpha: 1)))
                                    .padding(.bottom, 5)
                                
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 65, height: 65)
                                    .foregroundColor(Color(#colorLiteral(red: 0.6356717139, green: 0.6356717139, blue: 0.6356717139, alpha: 1)))
                            }.offset(x: 125, y: 50)
                        }
                        
                        
                    }
                    .onReceive(timer) { _ in
                        vm.updateCountdown()
                    }
 
                }
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            var GPTResponse: String = "Ramen, 300 kcal."
            var GPTResponseParsed: (String, Int?) = ("Unrecognized food", 0)
            var notificationString: String = "Ramen, 300 kcal."
            var base64String = ""
            if let imageData = image?.jpegData(compressionQuality: 0.1) {
                base64String = imageData.base64EncodedString()
            }
            if base64String == "" {
                notificationText = "No photo selected."
                showNotification = true
            } else {
                guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
                      let payload = """
      {
        "model": "gpt-4-vision-preview",
        "max_tokens": 30,
        "messages": [
            {
                "role": "system",
                "content": [{"type": "text", "text": "You are a helpful and professional Diat Analyst."}]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "Read the photo of a meal. Please responde with minimal number of words (at most 3 words) describing what food it is, and a number (not a range) indicating the estimated energy this meal includes in kilogram calories. Format the response as: [FOOD] @ [ENERGY] kcal."
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": "data:image/jpeg;base64,{\(base64String)}",
                            "detail": "low"
                        }
                    }
                ]
            }
        ]
      }
    """.data(using: .utf8) else
                {
                    return
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
                        GPTResponse = String(String(str.components(separatedBy: "\"}, \"finish_details\": ")[0]).components(separatedBy: "content\": \"")[1])
                        GPTResponseParsed = GPTResponseParser(GPTResponse: GPTResponse)
                        notificationString = GPTResponseParsed.0 + ", " +  String(GPTResponseParsed.1 ?? 0) + " kcal."
//                        GPTResponseParsed = GPTResponseParser(GPTResponse: GPTResponse).0 + ", " +  String(GPTResponseParser(GPTResponse: GPTResponse).1 ?? 0) + " kcal."
                        print(GPTResponse)
                        print(GPTResponseParsed)
                    }
                }.resume()
                semaphore.wait()
                notificationText = notificationString
                showNotification = true
            }
        }) {
            let _ = print(self.$showImagePicker)
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            
        }
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
        

    
    let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE HH:mm:ss"
            return formatter
        }()
    
}

struct BannerNotification: View {
    let text: String
    let color: Color
    @Binding var showNotification: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            if showNotification {
                VStack {
                    Text(text)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(color)
                }
                .transition(.move(edge: .top))
                .animation(.easeInOut)
                .onAppear {
                    if (text != "No photo selected.") {
                        uploadRecordToDB(userId: 2, info: text)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            self.hide()
                        }
                    }
                }
                Spacer()
            }
        }
        
    }
    // TODO: should be fine but haven't tested it yet
    private func uploadRecordToDB(userId: Int, info: String) {
        let userData = ReadUserData()
        let users = userData.users
        
        var userHeight: Double = 0.0
        var userWeight: Double = 0.0

        if let user = users.first(where: { $0.UserID == userId }) {
            userHeight = user.Height
            userWeight = user.Weight
        }
        print("userHeight: \(userHeight)")
        print("userWeight: \(userWeight)")
        
        let components = info.components(separatedBy: ", ")
        let food = components.first ?? ""
        let caloriesString = components.last?.replacingOccurrences(of: " kcal", with: "") ?? ""
        let calories = Double(caloriesString) ?? 0.0
        
        print("food: \(food)")
        print("calories: \(calories)")
        
        let timestamp = Timestamp()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = timestamp.dateValue()
        let dateString = dateFormatter.string(from: date)
        FirebaseDataManager.writeRecord(record: Record(userId: 2, recordId: 240, timestamp: dateString, weight: userWeight, height: userHeight, foodCategory: food, calories: Int(calories) ?? 0))
    }
    
    private func hide() {
        //hide the notification
        showNotification = false
    }
}

struct Calories: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case Food
        case Calories
    }
    
    var id = UUID()
    var Food: String
    var Calories: Int
}
class ReadData: ObservableObject  {
    @Published var calories = [Calories]()
    init(){
        loadData()
    }
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "Calories", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedCalories = try decoder.decode([Calories].self, from: data)
            self.calories = decodedCalories
        } catch {
            print("Failed to decode JSON: \(error)")
        }
        
    }
}
// user info
struct UserInfo: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case UserID
        case UserEmail
        case Gender
        case Height
        case Weight
        case Age
        case FirstEat
        case Streak
    }
    
    var id = UUID()
    var UserID: Int
    var UserEmail: String
    var Gender: String
    var Height: Double
    var Weight: Double
    var Age: Int
    var FirstEat: String
    var Streak: Int
    
}

class ReadUserData: ObservableObject  {
    @Published var users = [UserInfo]()
    init(){
        loadUserData()
    }
    func loadUserData()  {
        guard let url = Bundle.main.url(forResource: "User", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedUsers = try decoder.decode([UserInfo].self, from: data)
            self.users = decodedUsers
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
}

struct AddRecordSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @State private var recordInputCount = 1
    @State private var showRecordOutBoundAlert = false
    @State var allFood = ""
    @State var totalCalories = 0.0
    
    
    var body: some View {
        ScrollView {
            VStack {
                HStack (spacing: 20){
                    Image(systemName: "fork.knife")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue.opacity(0.5))
                    
                    
                    Text("Record Meal")
                        .font(.custom("Kalam-Bold", size: 35))
                        .foregroundColor(.black)
                        .padding()
                    
                    Button(action: {
                        recordInputCount += 1
                        if (recordInputCount > 4) {
                            showRecordOutBoundAlert = true
                        }
                    }) {
                        Image(systemName: "plus.square.on.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue.opacity(0.7))
                    }.alert("Record Number Exceed Bound", isPresented: $showRecordOutBoundAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    
                }.padding(.bottom, 30)
                
                HStack {
                    Text("Food")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .frame(width: 100)
                        .offset(x: 20)
                    Text("Weight")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .frame(width: 100)
                        .offset(x: 30)
                    Text("Calculated Calories")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .frame(width: 200)
                        .offset(x: 10)
                }
                .frame(maxWidth: 350)
                .padding(.bottom, 0)
                
                ForEach(0..<recordInputCount, id: \.self) { index in
                    RecordInput(allFood: $allFood, totalCalories: $totalCalories)
                }
                
                VStack {
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                    Text("Total Calories Calculated: \(String(format: "%.2f", totalCalories))")
                        .font(.custom("Kalam-Bold", size: 20))
                        .foregroundColor(.gray)
                        .padding()
                }.padding(.bottom, 5)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.blue.opacity(0.3))
                        .frame(width: 120, height: 60)
                    
                    Button(action: {
                        isPresented = false
                        uploadRecord(userId: 2, food: allFood, calories: totalCalories)
                        
                    }) {
                        Text("Record")
                            .font(.custom("Kalam-Bold", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }

            }
        }
        .frame(maxWidth: .infinity, maxHeight: 800)
        .padding(.top, 16)
    }
    
    func uploadRecord(userId: Int, food: String, calories: Double) {
        let userData = ReadUserData()
        let users = userData.users
        
        var userHeight: Double = 0.0
        var userWeight: Double = 0.0

        if let user = users.first(where: { $0.UserID == userId }) {
            userHeight = user.Height
            userWeight = user.Weight
        }
        
        let timestamp = Timestamp()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = timestamp.dateValue()
        let dateString = dateFormatter.string(from: date)
        FirebaseDataManager.writeRecord(record: Record(userId: 2, recordId: 240, timestamp: dateString, weight: userWeight, height: userHeight, foodCategory: allFood, calories: Int(totalCalories)))
    }
}

struct RecordInput: View {
    @State var food = ""
    @State var weight: Double = 0.0
    @ObservedObject var calories_data = ReadData()
    @Binding var allFood: String
    @Binding var totalCalories: Double
    @State private var previousValue: Double = 0.0
    @State private var previousFood: String = ""
    
    var body: some View {
        HStack {
            VStack {
                TextField("Ramen", text: $food)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 1, x: 0, y: 1)
            .frame(width: 130)
            
            VStack {
                TextField("", value: $weight, format: .number)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 1, x: 0, y: 1)
            .frame(width: 100)
            
            Spacer()
            
            if (food != "" && weight != 0.0) {
                VStack {
                    if let matchingFood = calories_data.calories.first(where: { $0.Food.lowercased() == food.lowercased() }) {
                        let calculatedCalories = Double(matchingFood.Calories) * weight / 100
                        let formattedCalories = String(format: "%.1f", calculatedCalories)
                        Text("\(formattedCalories)")
                            .foregroundColor(.black)
                            .textFieldStyle(.plain)
                            .autocapitalization(.none)
                            .frame(width: 100, height: 20)
                            .onChange(of: calculatedCalories) { newValue in
                                totalCalories = totalCalories - previousValue + newValue
                                previousValue = newValue
                            }
                            .onAppear {
                                updateAllFood(food)
                            }
                        
                    } else if let containFood = calories_data.calories.first(where: { $0.Food.lowercased().contains(food.lowercased()) }) {
                        let calculatedCalories = Double(containFood.Calories) * weight / 100
                        let formattedCalories = String(format: "%.1f", calculatedCalories)
                        Text("\(formattedCalories)")
                            .foregroundColor(.black)
                            .textFieldStyle(.plain)
                            .autocapitalization(.none)
                            .frame(width: 100, height: 20)
                            .onChange(of: calculatedCalories) { newValue in
                                totalCalories = totalCalories - previousValue + newValue
                                previousValue = newValue
                            }
                            .onAppear {
                                updateAllFood(food)
                            }
                    } else {
                        Text("Null")
                            .foregroundColor(.black)
                            .textFieldStyle(.plain)
                            .autocapitalization(.none)
                            .frame(width: 100, height: 20)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 1)
            }
            
        }
        .frame(maxWidth: 400)
        .padding()
    }
    func updateAllFood(_ newFood: String) {
        if !previousFood.isEmpty {
            if allFood.contains(", \(previousFood)") {
                allFood = allFood.replacingOccurrences(of: ", \(previousFood)", with: "")
            } else {
                allFood = allFood.replacingOccurrences(of: previousFood, with: "")
            }
        }
        if !allFood.isEmpty && !newFood.isEmpty {
            allFood.append(", ")
        }
        allFood.append(newFood)
        previousFood = newFood
    }
}



struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
