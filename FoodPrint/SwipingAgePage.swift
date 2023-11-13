//
//  SwipingAgePage.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 6/11/2023.
//

import Foundation
import SwiftUI

struct SwipingAgePageView: View {
    @State private var selectedAge = 22
    
    var body: some View {
        VStack {
            Text("How old are you?")
                .font(.custom("Kalam-Bold", size: 30))
                .padding(.bottom, 50)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            Image("age")
                .resizable()
                .frame(width: 250, height: 250)
                .cornerRadius(30)
                .padding(.bottom, 30)
            
            Picker("Age", selection: $selectedAge) {
                ForEach(1...120, id: \.self) { age in
                    Text("\(age)")
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            
            Text("Selected Age: \(selectedAge)")
                .font(.custom("Kalam-Regular", size: 20))
        }
    }
}

struct SwipingAgePageView_Previews: PreviewProvider {
    static var previews: some View {
        SwipingAgePageView()
    }
}
