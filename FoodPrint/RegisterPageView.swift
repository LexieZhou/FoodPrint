//
//  RegisterPageView.swift
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


struct RegisterPageView: View {
    @State var email = ""
    @State var password = ""
    @State var successRegister = false
    @State private var showUnsucessAlert = false
    @State private var showSucessAlert = false
    @State private var showNextPage = false
    
    var body: some View {
        if (showNextPage) {
//            PreviewContainerView(controller: ViewController())
            NavigationLink(
                destination: PreviewContainerView(controller: ViewController()).navigationBarBackButtonHidden(true),
                isActive: $showNextPage,
                label: { EmptyView() }
            )
        } else {
            content
        }
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                showUnsucessAlert = true
            }
            else {
                showSucessAlert = true
            }
        }
    }

    var content: some View {
        NavigationView {
            ZStack{
                VStack{
                    Text("Sign up")
                        .font(.custom("Kalam-Bold", size: 50))
                        .padding(.bottom, 50)
                        .padding(.top, 10)
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
                        .padding(.bottom)
                    
                    Button{
                        register()
                    } label: {
                        Text("Sign up")
                            .bold()
                            .font(.custom("Kalam-Bold", size: 20))
                            .foregroundColor(.black)
                            .frame(width: 150, height: 40)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    .offset(y: 80)
                    .alert("Unsucessful Register", isPresented: $showUnsucessAlert){
                        Button("Okay", role: .cancel){}
                    }
                    .alert("Register Successfully!🐶", isPresented: $showSucessAlert){
                        Button("Okay", role: .cancel){
                            showNextPage = true
                            print("show next page")
                        }
                    }
                    NavigationLink(destination: TabPageView().navigationBarBackButtonHidden(true)){
                        Image("fastingClock")
                            .resizable()
                            .frame(width: 250, height: 140)
                    }
                    .padding(.top)
                    .offset(x: 100, y: 170)
                }
                .frame(width: 280)
            }
            .ignoresSafeArea()
            .padding(.bottom, 100)
        }
        
    }
        
}


struct RegisterPageView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPageView()
    }
}
