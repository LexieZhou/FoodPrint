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
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    @State private var showNotification: Bool = false
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    
    var body: some View {
        
        
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
                    
                }
                .onReceive(timer) { _ in
                    vm.updateCountdown()
                }
                
                
                
                
                //MARK: camera
                ZStack {
                    VStack {
                        if vm.isActive {
                            Button(action: {
                                self.showSheet = true
                            }) {
                                Image("camera-icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .frame(width: 100, height: 100)
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
                            }.sheet(isPresented: $showImagePicker, onDismiss: {
                                showNotification = true
                            }) {
                                //image
                                VStack {
                                    
                                    ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
                                }
                                .padding()
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }

                
                
                
                
            }
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

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
