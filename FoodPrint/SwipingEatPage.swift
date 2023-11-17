//
//  SwipingEatPage.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 6/11/2023.
//

import Foundation
import SwiftUI
import UIKit

struct SwipingEatPageView: View {
    @State private var selectedTime = Date()
    
    var body: some View {
        VStack {
            Text("When do you usually eat the \(Text("first").foregroundColor(.blue)) meal of the day?")
                .font(.custom("Kalam-Bold", size: 30))
                .padding(.bottom, 20)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding([.leading, .trailing], 30)
            
            Image("eat")
                .resizable()
                .frame(width: 250, height: 230)
                .cornerRadius(30)
            
            DatePicker(
                "Select Time",
                selection: $selectedTime,
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            Text("Selected Time: \(formattedTime(selectedTime))")
                .font(.custom("Kalam-Regular", size: 20))
        }
    }
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

struct SwipingEatPageView_Previews: PreviewProvider {
    static var previews: some View {
        SwipingEatPageView()
    }
}
