//
//  ContentView.swift
//  ascendiaApp
//
//  Created by Roberto Aburto  on 08/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showRegisterView = false

    var body: some View {
        ZStack {
            // Fondo con degradado suave
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.92, blue: 0.98),
                    Color(red: 0.98, green: 0.94, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Logo PNG
                    Image("ascendia_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                        .accessibilityLabel("Logo de Ascendia")
                    
                    // Nombre de la app
                    Text("ASCENDIA")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    
                    // Subtítulo
                    Text("Red Social Segura e Inclusiva")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                }
                .padding(.top, 60)

                    // Tarjeta de inicio de sesión
                    VStack(spacing: 20) {
                        // Campo de correo electrónico
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo electrónico")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            TextField("example@email.com", text: $email)
                                #if os(iOS)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                #endif
                                .textContentType(.emailAddress)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5), lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                        }

                        // Campo de contraseña
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            HStack {
                                if isPasswordVisible {
                                    TextField("", text: $password)
                                } else {
                                    SecureField("", text: $password)
                                }

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5), lineWidth: 1.5)
                            )
                            .cornerRadius(12)
                        }

                        // ¿Olvidaste tu contraseña?
                        HStack {
                            Spacer()
                            Button(action: {
                                // Acción para recuperar contraseña
                            }) {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                            }
                        }

                        // Botón de iniciar sesión
                        Button(action: {
                            // Acción de inicio de sesión
                        }) {
                            Text("Iniciar sesión")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.8),
                                            Color(red: 0.9, green: 0.2, blue: 0.6)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 10)
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.purple.opacity(0.1), radius: 15, x: 0, y: 5)
                    .padding(.horizontal, 30)

                    // Sección de crear cuenta
                    VStack(spacing: 15) {
                        Text("¿No tienes una cuenta?")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        Button(action: {
                            showRegisterView = true
                        }) {
                            Text("Crear cuenta")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                                )
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showRegisterView) {
            RegisterView()
        }
        #else
        .sheet(isPresented: $showRegisterView) {
            RegisterView()
        }
        #endif
    }
}

#Preview {
    ContentView()
}
