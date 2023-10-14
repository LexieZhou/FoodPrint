//
//  MainPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI

struct TabPageView: View {
    var body: some View {
        TabView {
            HomePageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Fasting", systemImage: "fork.knife.circle")
                }
            ChatbotPageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Chatbot", systemImage: "fork.knife.circle")
                }
            RecordPageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Records", systemImage: "calendar.circle")
                }
            ProfilePageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

struct TabPageView_Previews: PreviewProvider {
    static var previews: some View {
        TabPageView()
    }
}
