//
//  LoginPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI
import AVFoundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginPageView: View {
    @State var email = ""
    @State var password = ""
    @State private var successLogin = false
    @State private var showingUnsuccessAlert = false
    
    var body: some View {
        if (successLogin) {
            TabPageView().navigationBarBackButtonHidden(true)
        } else {
            content
        }
    }
    
    var content: some View {
        NavigationView {
            ZStack{
                VStack{
                    Text("Login")
                        .font(.custom("Kalam-Bold", size: 50))
                        .padding(.bottom, 50)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    TextField("Email", text: $email)
                        .foregroundColor(.gray)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)

                    Rectangle()
                        .frame(width: 280, height: 1)
                        .foregroundColor(.gray)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.gray)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)

                    Rectangle()
                        .frame(width: 280, height: 1)
                        .foregroundColor(.gray)
                    
                    Button{
                        login()
                    } label: {
                        Text("Go!")
                            .bold()
                            .font(.custom("Kalam-Bold", size: 20))
                            .foregroundColor(.black)
                            .frame(width: 150, height: 40)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(10)
                    }
                    .alert("Unsuccessful Login", isPresented: $showingUnsuccessAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .padding(.top)
                    .offset(y: 80)
                    
                    NavigationLink(destination: RegisterPageView().navigationBarBackButtonHidden(true)){
                        Text("No account? Register One!")
                            .bold()
                            .font(.custom("Kalam-Bold", size: 20))
                            .foregroundColor(.black)
                            .underline()
                    }
                    .padding(.top)
                    .padding(.bottom, 10)
                    .offset(y: 85)
                    .frame(width: 350)
                    
                    NavigationLink(destination: TabPageView().navigationBarBackButtonHidden(true)){
                        Image("fastingClock")
                            .resizable()
                            .frame(width: 250, height: 140)
                    }
                    .padding(.top)
                    .offset(x: 100, y: 150)
                }
                .frame(width: 280)
            }
            .ignoresSafeArea()
            .padding(.bottom, 100)
        }
    }
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                showingUnsuccessAlert = true
            } else {
                successLogin = true
                print("success")
            }
        }
    }
}


struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
