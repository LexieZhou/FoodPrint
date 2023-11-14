//
//  HomePageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI

struct HomePageView: View {
    @State var progress = 0.5
    @State private var showAlert = false
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showingAddRecord = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    @State private var showNotification: Bool = false
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                if showNotification {
                    BannerNotification(text: "Photo selected!", color: .green, showNotification: $showNotification)
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
                            .alert("Are you sure you want to stop early? If you are fasting, you will fail today!", isPresented: $showAlert) {
                                Button("Yes", action: vm.stopEarly)
                                Button("Cancel", role: .cancel) {
                                    vm.showingAlert = false
                                }
                            }
                        }
                        
                        //MARK: camera
                        if vm.isActive {
                            VStack {
                                Button(action: {
                                    self.showSheet = true
                                }) {
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.7))
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
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.7))
                                }.sheet(isPresented: $showingAddRecord) {
                                    AddRecordSheet(isPresented: $showingAddRecord)
                                }
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
            showNotification = true
        }) {
            let _ = print(self.$showImagePicker)
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            
        }
    }
        
        
//        ZStack(alignment: .top) {
//            if showView {
//                    RoundedRectangle(cornerRadius: 15)
//                      .fill(Color.blue)
//                      .frame(
//                        width: UIScreen.main.bounds.width * 0.9,
//                        height: UIScreen.main.bounds.height * 0.1
//                      )
//                      .transition(.asymmetric(
//                        insertion: .move(edge: .top),
//                        removal: .move(edge: .top)
//                      ))
//            }
//        }
//
    
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
    
    private func hide() {
        //hide the notification
        showNotification = false
    }
}


struct RecordInput: View {
    @State var food = ""
    @State var weight = ""
    @ObservedObject var calories_data = ReadData()
//    @Binding var totalCalories: Double
    
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
            .frame(width: 100)
            
            VStack {
                TextField("60", text: $weight)
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
            
            if (food != "" && weight != "") {
                VStack {
                    if let matchingFood = calories_data.calories.first(where: { $0.Food.lowercased() == food.lowercased() }) {
                        if let weightValue = Double(weight), let caloriesValue = Double(matchingFood.Calories) {
                            let calculatedCalories = caloriesValue * weightValue / 100
                            let formattedCalories = String(format: "%.1f", calculatedCalories)
                            Text("\(formattedCalories)")
                                .foregroundColor(.black)
                                .textFieldStyle(.plain)
                                .autocapitalization(.none)
                                .frame(width: 100, height: 20)
//                                .onChange(of: calculatedCalories) { newValue in
//                                    totalCalories += newValue
//                                }
                        } else {
                            Text("Invalid weight or calories")
                                .foregroundColor(.black)
                                .textFieldStyle(.plain)
                                .autocapitalization(.none)
                                .frame(width: 100, height: 20)
                        }
                    } else if let anyFood = calories_data.calories.first {
                        Text("\(anyFood.Calories)")
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

struct AddRecordSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @State private var recordInputCount = 1
    @State private var showRecordOutBoundAlert = false
//    @State var totalCalories = 0.0
    
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
                        // add record
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
                    Text("Weight")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .frame(width: 100)
                    Spacer()
                    Text("Calculated Calories")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .frame(width: 200)
                }
                .frame(maxWidth: 350)
                .padding(.bottom, 0)
                
                ForEach(0..<recordInputCount, id: \.self) { index in
//                    RecordInput(totalCalories: $totalCalories)
                    RecordInput()
                }
                
                VStack {
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
//                    Text("Total Calories Calculated: \(totalCalories)")
//                        .font(.custom("Kalam-Bold", size: 20))
//                        .foregroundColor(.gray)
//                        .padding()
                }.padding(.bottom, 5)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.blue.opacity(0.3))
                        .frame(width: 120, height: 60)
                    
                    Button(action: {
                        // save action
                        isPresented = false
                        
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
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
