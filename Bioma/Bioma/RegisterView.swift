//
//  RegisterView.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 28/03/25.
//

import SwiftUI

// Extendemos la clase Color para definir nuestros colores personalizados
extension Color {
    static let biomaDarkGreen = Color(red: 0x11 / 255, green: 0x8B / 255, blue: 0x50 / 255) // #118B50
    static let biomaLightGreen = Color(red: 0x5D / 255, green: 0xB9 / 255, blue: 0x96 / 255) // #5DB996
    static let biomaYellow = Color(red: 0xE3 / 255, green: 0xF0 / 255, blue: 0xAF / 255) // #E3F0AF
    static let biomaBeige = Color(red: 0xFB / 255, green: 0xF6 / 255, blue: 0xE9 / 255) // #FBF6E9
}

// Vista para registro de usuarios
struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("BiomaLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                HStack {
                    (Text("Tu voz. Tu ") +
                     Text("Bioma")
                        .foregroundColor(.biomaLightGreen)
                        .bold()
                        .italic() +
                     Text(". Tu ciudad."))
                    .font(.system(size: 20))
                    .padding(.bottom, 20)
                    .foregroundColor(Color.black)
                }
                
                Text("Registrarse")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                
                TextField("Nombre de usuario", text: $username)
                    .padding()
                    .environment(\.colorScheme, .light)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.biomaDarkGreen, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                
                TextField("Correo electrónico", text: $email)
                    .padding()
                    .environment(\.colorScheme, .light)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.biomaDarkGreen, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                
                SecureField("Contraseña", text: $password)
                    .padding()
                    .environment(\.colorScheme, .light)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.biomaDarkGreen, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                
                SecureField("Confirmar Contraseña", text: $confirmPassword)
                    .padding()
                    .environment(\.colorScheme, .light)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.biomaDarkGreen, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                
                Button(action: {
                    if password == confirmPassword {
                        UserDefaults.standard.set(password, forKey: email)
                        navigateToLogin = true
                    }
                }) {
                    Text("Registrarse")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.biomaLightGreen)
                        .cornerRadius(10)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                }
                
                // Botón para ir a la pantalla de inicio de sesión
                Button(action: {
                    navigateToLogin = true
                }) {
                    Text("¿Ya tienes una cuenta? Inicia sesión")
                        .foregroundColor(.biomaDarkGreen)
                        .underline()
                        .font(.system(size: 16))
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.biomaBeige)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// Vista previa para el diseño
#Preview {
    RegisterView()
}
