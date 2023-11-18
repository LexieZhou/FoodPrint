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
                    Label("Fasting", systemImage: "fork.knife.circle.fill")
                }
            ChatbotPageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("ChatBot", systemImage: "message.circle.fill")
                }
            RecordPageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Record", systemImage: "calendar.circle.fill")
                }
            ProfilePageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

struct TabPageView_Previews: PreviewProvider {
    static var previews: some View {
        TabPageView()
    }
}
