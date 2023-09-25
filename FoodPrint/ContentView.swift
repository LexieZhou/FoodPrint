//
//  ContentView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 25/9/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack{
                
                Text("Welcome to\nFoodprint")
                    .font(.custom("Kalam-Bold", size: 40))
                    .padding(.bottom, 50)
                    .padding(.top,10)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Text("Tap to Start")
                    .font(.custom("Kalam-Bold", size: 35))
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 50)
                    .cornerRadius(8)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 60)
                Image("fastingImg")
                    .resizable()
                    .frame(width: 350, height: 200)
                    .cornerRadius(30)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
