//
//  ContentView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 25/9/2023.
//

import SwiftUI

struct WelcomePageView: View {
    @State private var isFlashing = false
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: LoginPageView().navigationBarBackButtonHidden(true)) {
                ZStack {
                    Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Welcome to\nFoodprint")
                            .font(.custom("Kalam-Bold", size: 40))
                            .padding(.bottom, 200)
                            .padding(.top, 10)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Text("Tap to Start 🍽")
                            .font(.custom("Kalam-Bold", size: 30))
                            .foregroundColor(.gray)
                            .frame(width: 220, height: 50)
                            .cornerRadius(8)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 60)
                            .opacity(isFlashing ? 1.0 : 0.4)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                                    isFlashing = true
                                }
                            }
                    }
                    .navigationBarHidden(true)
                }
            }
        }
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
