//
//  SwipingHeightPage.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 6/11/2023.
//

import Foundation
import SwiftUI

struct SwipingHeightPageView: View {
    @State private var height = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What's your height?")
                .font(.custom("Kalam-Bold", size: 30))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.bottom, 30)
            
            Image("height")
                .resizable()
                .frame(width: 250, height: 250)
                .cornerRadius(30)
                .padding(.bottom, 30)
            
            VStack {
                HStack {
                    TextField("", text: $height)
                        .font(.custom("Kalam-Bold", size: 40))
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                    
                    Text("cm")
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
        .padding(.bottom, 30)
    }
}

struct SwipingHeightPageView_Previews: PreviewProvider {
    static var previews: some View {
        SwipingHeightPageView()
    }
}
