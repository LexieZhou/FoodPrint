//
//  SwipingGenderPage.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 6/11/2023.
//

import Foundation
import SwiftUI

struct SwipingGenderPageView: View {
    @State private var gender: Gender?
    
    var body: some View {
        VStack {
            Text("What's your gender?")
                .font(.custom("Kalam-Bold", size: 30))
                .padding(.bottom, 50)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Image("gender")
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(30)
                .padding(.bottom, 50)
            
            HStack {
                Button{
                    gender = .male
                } label: {
                    Text("Male")
                        .bold()
                        .font(.custom("Kalam-Bold", size: 20))
                        .foregroundColor(.black)
                        .frame(width: 80, height: 40)
                        .background(gender == .male ? Color.blue.opacity(0.5) : Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
                Button{
                    gender = .female
                } label: {
                    Text("Female")
                        .bold()
                        .font(.custom("Kalam-Bold", size: 20))
                        .foregroundColor(.black)
                        .frame(width: 80, height: 40)
                        .background(gender == .female ? Color.blue.opacity(0.5) : Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
                Button{
                    gender = .others
                } label: {
                    Text("Others")
                        .bold()
                        .font(.custom("Kalam-Bold", size: 20))
                        .foregroundColor(.black)
                        .frame(width: 80, height: 40)
                        .background(gender == .others ? Color.blue.opacity(0.5) : Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
            }
        }
    }
}
enum Gender: String {
    case male = "Male"
    case female = "Female"
    case others = "Others"
}
struct SwipingGenderPageView_Previews: PreviewProvider {
    static var previews: some View {
        SwipingGenderPageView()
    }
}
