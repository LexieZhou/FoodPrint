
//  ProfilePageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI

struct ProfilePageView: View {
    @State private var showingEditSheet = false
    @State private var showingRankingSheet = false
    
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
                                .foregroundColor(Color.yellow.opacity(0.2))
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
                                .foregroundColor(Color.green.opacity(0.2))
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
                                .foregroundColor(Color.blue.opacity(0.2))
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
                    Button{showingEditSheet.toggle()} label: {
                        Text("Edit Information")
                            .font(.custom("Kalam-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showingEditSheet) {
                        EditSheet()
                    }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.gray)
                    Button{showingRankingSheet.toggle()} label: {
                        Text("See Rankings")
                            .font(.custom("Kalam-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showingRankingSheet) {
                        RankingSheet()
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

struct EditSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var gender = ""
    @State var height = ""
    @State var weight = ""
    @State var time = ""

    var body: some View {
        VStack {
            HStack (spacing: 20){
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.blue)
                
                Text("Edit Information")
                    .font(.custom("Kalam-Bold", size: 35))
                    .foregroundColor(.black)

            }.padding(.bottom, 20)
            
            VStack {
                Text("Gender")
                    .font(.custom("Kalam-Bold", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    TextField("Female", text: $gender)
                        .foregroundColor(.gray)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 1)
                Text("Height")
                    .font(.custom("Kalam-Bold", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    TextField("160cm", text: $height)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 1)
                
                Text("Weight")
                    .font(.custom("Kalam-Bold", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    TextField("70kg", text: $weight)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 1)
                
                Text("The usual FIRST meal time")
                    .font(.custom("Kalam-Bold", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    TextField("7:00am", text: $time)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 1, x: 0, y: 1)
            }
            .frame(width: 250)
            .padding(.bottom, 40)

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 60)
                
                Button(action: {
                    // Button action
                }) {
                    Text("Save")
                        .font(.custom("Kalam-Bold", size: 30))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
struct Rank: View {
    
    var ranking: Int
    var name: String
    var days: Int
    
    var body: some View {
        Rectangle()
            .frame(width: 350, height: 1)
            .foregroundColor(.gray)
        HStack (spacing: 30){
            Image(systemName: "\(ranking).circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.yellow)
            Text(name)
                .font(.custom("Kalam-Bold", size: 20))
                .foregroundColor(.black)
            
            Spacer()
        
            Text("\(days) Days")
                .font(.custom("Kalam-Bold", size: 20))
                .foregroundColor(.black)
            
        }.frame(maxWidth: 280, alignment: .leading)
    }
}
struct RankingSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack (spacing: 20){
                Image(systemName: "crown.fill")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .foregroundColor(.yellow)
                
                Text("Fasting Streak Days Ranking")
                    .font(.custom("Kalam-Bold", size: 35))
                    .foregroundColor(.black)

            }.padding(.bottom, 20)
            Rank(ranking: 1, name: "Bob", days: 180)
            Rank(ranking: 2, name: "Sistine", days: 178)
            Rank(ranking: 3, name: "Boao", days: 178)
            Rank(ranking: 4, name: "Larry", days: 166)
            Rank(ranking: 5, name: "Lexie", days: 145)
            Rank(ranking: 6, name: "Alice", days: 120)
            Rank(ranking: 7, name: "Jenny", days: 113)
            Rank(ranking: 8, name: "Harper", days: 101)
        }
    }
}
