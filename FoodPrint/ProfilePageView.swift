
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
                        Image("avatar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                )
                            .offset(x: 0, y: 20)
                            
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .offset(x: -34, y: 60)
                        
                        VStack (alignment: .leading){
                            Text("Jenny")
                                .font(.custom("Kalam-Bold", size: 40))
                                .padding(.bottom, 2)
                                .padding(.top, 10)
                                .offset(y: 20)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                            Text("Chocolate Lover")
                                .font(.custom("Kalam-Regular", size: 15))
                                .foregroundColor(Color.gray)
                            
                            Text("Trying to be healthy")
                                .font(.custom("Kalam-Regular", size: 15))
                                .foregroundColor(Color.gray)
                                
                        }
                    }
                    .padding(.bottom, 40)
                    
                    HStack (spacing: 20){
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 95, height: 60)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 3, x: 0, y: 1)
                            
                            VStack {
                                Text("Height")
                                    .font(.custom("Kalam-Bold", size: 20))
                                    .foregroundColor(.black)
                                Text("160 cm")
                                    .font(.custom("Kalam-Regular", size: 17))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 95, height: 60)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 3, x: 0, y: 1)
                            
                            VStack {
                                Text("Weight")
                                    .font(.custom("Kalam-Bold", size: 20))
                                    .foregroundColor(.black)
                                Text("55 kg")
                                    .font(.custom("Kalam-Regular", size: 17))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 95, height: 60)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 3, x: 0, y: 1)
                            
                            VStack {
                                Text("Streak")
                                    .font(.custom("Kalam-Bold", size: 20))
                                    .foregroundColor(.black)
                                Text("40 days")
                                    .font(.custom("Kalam-Regular", size: 17))
                                    .foregroundColor(.black)
                            }
                        }
                        
                    }
                    .padding(.bottom, 80)
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                    Button{} label: {
                        Text("Edit Information")
                            .font(.custom("Kalam-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                    Button{} label: {
                        Text("See Rankings")
                            .font(.custom("Kalam-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                    Button{} label: {
                        Text("Log Out")
                            .font(.custom("Kalam-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 140)
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
