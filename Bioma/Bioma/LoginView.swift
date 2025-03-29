//
//  LoginView.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 28/03/25.
//

import SwiftUI

// Vista de inicio de sesión (Login)
struct LoginView: View {
    @State private var email = "" // Almacena el correo electrónico ingresado
    @State private var password = "" // Almacena la contraseña ingresada
    @State private var navigateToRegister = false // Estado para controlar la navegación al registro
    @State private var navigateToIndex = false // Estado para controlar la navegación a la pantalla de inicio
    
    var body: some View {
        // NavigationStack para manejar la navegación entre vistas
        NavigationStack {
            VStack {
                // Logo de la aplicación
                Image("BiomaLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                // Título de la aplicación con texto estilizado
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
                
                // Título de la sección de inicio de sesión
                Text("Iniciar sesión")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                
                // Campo para ingresar el correo electrónico
                TextField("Correo electrónico", text: $email)
                    .padding()
                    .environment(\.colorScheme, .light) // Establece el esquema de color claro
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Bordes redondeados para el campo de texto
                            .stroke(Color.biomaDarkGreen, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                // Campo para ingresar la contraseña (campo seguro)
                SecureField("Contraseña", text: $password)
                    .padding()
                    .environment(\.colorScheme, .light) // Establece el esquema de color claro
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Bordes redondeados para el campo de contraseña
                            .stroke(Color.biomaDarkGreen, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    .autocapitalization(.none) // Desactiva la autocapitalización
                    .disableAutocorrection(true) // Desactiva la autocorrección
                
                // Botón para iniciar sesión
                Button(action: {
                    // Acción para navegar a la pantalla principal después de iniciar sesión
                    navigateToIndex = true
                }) {
                    Text("Iniciar sesión")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.biomaLightGreen)
                        .cornerRadius(10)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                }
                // Navegación hacia la pantalla principal después de iniciar sesión
                .navigationDestination(isPresented: $navigateToIndex) {
                    IndexView() // Redirige a la vista principal
                        .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso en la vista de inicio
                
                }
                
                // Botón para navegar a la pantalla de registro
                Button(action: {
                    navigateToRegister = true
                }) {
                    Text("¿No tienes una cuenta? Regístrate")
                        .foregroundColor(.biomaDarkGreen)
                        .underline()
                        .font(.system(size: 16))
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegura que el contenido ocupe toda la pantalla
            .background(Color.biomaBeige) // Fondo beige
            .ignoresSafeArea() // Ignora las áreas seguras para extenderse por toda la pantalla
            // Navegación hacia la vista de registro
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView() // Redirige a la vista de registro
                    .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso en la vista de registro
            }
        }
    }
}

// Vista previa para el diseño de LoginView
#Preview {
    LoginView() // Muestra la vista previa de la vista de inicio de sesión
}

