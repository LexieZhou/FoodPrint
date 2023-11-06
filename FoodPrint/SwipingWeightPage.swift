//
//  SwipingWeightPage.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 6/11/2023.
//

import Foundation
import SwiftUI

struct SwipingWeightPageView: View {
    @State private var weight = ""
    
    var body: some View {
        VStack {
            Text("What's your current weight?")
                .font(.custom("Kalam-Bold", size: 30))
                .padding(.bottom, 50)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Image("measure_weight")
                .resizable()
                .frame(width: 300, height: 200)
                .cornerRadius(30)
                .padding(.bottom, 30)
            
            VStack {
                HStack {
                    TextField("", text: $weight)
                        .font(.custom("Kalam-Bold", size: 40))
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                    
                    Text("kg")
                        .font(.custom("Kalam-Bold", size: 20))
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .frame(maxWidth: 150)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .frame(maxWidth: 200)
            }
            .padding(.bottom, 0)
        }
    }
}

struct SwipingWeightPageView_Previews: PreviewProvider {
    static var previews: some View {
        SwipingWeightPageView()
    }
}
