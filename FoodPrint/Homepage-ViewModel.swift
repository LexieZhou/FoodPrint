//
//  Homepage-ViewModel.swift
//  FoodPrint
//
//  Created by Sistine Yu on 2023/10/30.
//

import Foundation
import SwiftUI
//https://github.com/federicoazzu/CustomCountdownTimer/blob/main/CustomCountdownTimer/Content-ViewModel.swift
//https://www.youtube.com/watch?v=NAsQCNpodPI
// https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates

extension HomePageView {
    final class ViewModel: ObservableObject {
        @Published var isEating = false //record whether the user is eating or fasting
        @Published var isActive = false //the whole timing system has started or not
        @Published var showingAlert = false //record whether the app is releasing an alert
        @Published var time: String = "" //recording the fasting/eating window finish time
        @Published var success: Bool = true
        @Published var eatingTime: Float = 8.0 {
            didSet {
                self.time = "\(Int(eatingTime)):00:00"
            }
        }//fixed or can be defined by users, unit is hours
        @Published var fastingTime: Float = 16.0 {
            didSet {
                self.time = "\(Int(fastingTime)):00:00"
            }
        }
        
        @Published var initialTime = Date()//should not be 0, should be current time
        @Published var endDate = Date() //ending time
        @Published var batteryImg = Image("Battery6")
        
        
        func startEating(eatingTime: Float) {
            self.isActive = true
            self.endDate = Date()
            self.isEating = true
            self.initialTime = Date()
            self.endDate = Calendar.current.date(byAdding: .hour, value: Int(eatingTime), to: endDate)!
        }
        
        func startFasting(fastingTime: Float) {
            self.isActive = true
            self.endDate = Date()
            self.isEating = false
            self.initialTime = Date()
            self.endDate = Calendar.current.date(byAdding: .hour, value: Int(fastingTime), to: endDate)!
        }
        
        func updateCountdown() {
            guard isActive else {return}
            
            //Get the current date and calculates time difference between current and end date
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970

//            print("eating time",Double(eatingTime))
//            print("diff", diff)
            if diff > 0 {
                if isEating {
                    if diff > 3600*5/6*Double(eatingTime) && diff <= 3600*Double(eatingTime) {
                        self.batteryImg = Image("Battery1")
                    } else if diff > 3600*2/3*Double(eatingTime) && diff <= 3600*5/6*Double(eatingTime){
                        self.batteryImg = Image("Battery2")
                    } else if diff > 3600*1/2*Double(eatingTime) && diff <= 3600*2/3*Double(eatingTime){
                        self.batteryImg = Image("Battery3")
                    } else if diff > 3600*1/3*Double(eatingTime) && diff <= 3600*1/2*Double(eatingTime){
                        self.batteryImg = Image("Battery4")
                    } else if diff > 3600*1/6*Double(eatingTime) && diff <= 3600*1/3*Double(eatingTime){
                        self.batteryImg = Image("Battery5")
                    } else if diff > 0 && diff <= 3600*1/6*Double(eatingTime){
                        self.batteryImg = Image("Battery6")
                    }
                } else {
                    if diff > 3600*5/6*Double(fastingTime) && diff <= 3600*Double(fastingTime) {
                        self.batteryImg = Image("Battery6")
                    } else if diff > 3600*2/3*Double(fastingTime) && diff <= 3600*5/6*Double(fastingTime){
                        self.batteryImg = Image("Battery5")
                    } else if diff > 3600*1/2*Double(fastingTime) && diff <= 3600*2/3*Double(fastingTime){
                        self.batteryImg = Image("Battery4")
                    } else if diff > 3600*1/3*Double(fastingTime) && diff <= 3600*1/2*Double(fastingTime){
                        self.batteryImg = Image("Battery3")
                    } else if diff > 3600*1/6*Double(fastingTime) && diff <= 3600*1/3*Double(fastingTime){
                        self.batteryImg = Image("Battery2")
                    } else if diff > 0 && diff <= 3600*1/6*Double(fastingTime){
                        self.batteryImg = Image("Battery1")
                    }
                }
            }
            
            
            //check the countdown
            if diff <= 0 {
                if isEating {
                    self.isEating = false
                    self.time = "00:00:00"
                    self.showingAlert = true
                    return
                } else {
                    self.isEating = true
                    self.time = "00:00:00"
                    self.showingAlert = true
                    return
                }
            }
            
            let date = Date(timeIntervalSince1970: diff)
//            print("date", date)
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "UTC")!
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
//            print("hour", hour)
            
            self.time = String(format: "%02d : %02d : %02d", hour, minutes, seconds)
        }
        
        func stopEarly() {
            self.time = "00:00:00"
            if isEating {
                startFasting(fastingTime: fastingTime)
            } else {
                success = false
                startEating(eatingTime: eatingTime)
            }
            
        }
    }
}
