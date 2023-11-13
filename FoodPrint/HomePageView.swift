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
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    
    var body: some View {
        
            
        ZStack {
            //background color to be dark blue
//            Color(#colorLiteral(red: 0.02478201501, green: 0.1914640367, blue: 0.2865158319, alpha: 1))
//                .ignoresSafeArea()
//            
//            //MARK: ring
//            Circle()
//                .stroke(lineWidth: 20)
//                .foregroundColor(.gray)
//                .opacity(0.1)
//            
            content
        }
        .onAppear {
            progress = 1
        }
        
    }
            

            
                
        
    
    let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE HH:mm:ss"
            return formatter
        }()
    
    var content: some View {
        VStack(spacing: 5) {
            
            VStack(spacing: 10) {
                if vm.isActive {
                    if vm.isEating {
                        Text("Eating Time!")
//                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .font(.title)
                            .opacity(0.7)
                    } else {
                        Text("You are fasting now!")
//                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .font(.title)
                            .opacity(0.7)
                    }
                } else {
                    //MARK: start eating button
                    Button("Tap here to start!"){
                        print("touch start eating button")
                        vm.startEating(eatingTime: vm.eatingTime)
                    }.font(.title)
                }

                
//                Text(Date(), formatter: formatter)
//                    .fontWeight(.bold)
                HStack(spacing: 5) {
                    Text(vm.initialTime, format: .dateTime.weekday().hour().minute().second()).fontWeight(.bold)
//                        .foregroundColor(.white)

                    if vm.isActive {
                        Text("->")
    //                        .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text(vm.endDate, format: .dateTime.weekday().hour().minute().second()).fontWeight(.bold)
    //                        .foregroundColor(.white)
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
    //                    .padding()
                    
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
                Text("\(vm.time)")                /*.foregroundColor(.white)*/
                    .alert("Timer done!", isPresented: $vm.showingAlert) {
                        Button("Continue") {
                            vm.startEating(eatingTime: vm.eatingTime)
                        }
                    }
                
                //MARK: stop early button
                Button("Stop Early") {
                    // Action to perform when the button is tapped
                    showAlert = true
                }
                .foregroundColor(.white)
                .padding(.all, 10)
                .background(Color.blue)
                .cornerRadius(10)
                .offset(x: 0, y: 10)
                .tint(.red)
                .alert("Are you sure you want to stop early?", isPresented: $showAlert) {
                    Button("Yes", action: vm.stopEarly)
                    Button("Cancel", role: .cancel) {
                        vm.showingAlert = false
                    }
                }
                

            }
            .onReceive(timer) { _ in
                vm.updateCountdown()
            }
            
                
            
            
            //MARK: camera
            Image("cameraIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: 100, height: 100)
        
            


            
            
        }
    }

    
}
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
