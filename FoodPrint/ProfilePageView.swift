
//  ProfilePageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI

struct ProfilePageView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Jenny")
                            .font(.custom("Kalam-Bold", size: 50))
                            .padding(.bottom, 50)
                            .padding(.top, 10)
                            .offset(y: 20)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 60)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                    Button{} label: {
                        Text("Profile Setting")
                            .font(.custom("Kalam-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                    
                }
            }
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
