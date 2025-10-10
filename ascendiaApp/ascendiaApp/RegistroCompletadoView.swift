//
//  RegistroCompletadoView.swift
//  ascendiaApp
//
//  Created by Claude Code on 10/10/25.
//

import SwiftUI

struct RegistroCompletadoView: View {
    @State private var showContent = false
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con degradado suave lila-rosa
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
                    VStack(spacing: 28) {
                        // HEADER: Ícono de escudo + título + subtítulo
                        VStack(spacing: 12) {
                            // Ícono redondeado con escudo blanco sobre degradado púrpura-fucsia
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.6, green: 0.4, blue: 0.8),
                                        Color(red: 0.9, green: 0.2, blue: 0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 20))

                                Image(systemName: "shield.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                            .accessibilityLabel("Ícono de seguridad")

                            // Título
                            Text("Registro Seguro")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .accessibilityAddTraits(.isHeader)

                            // Subtítulo
                            Text("Verificación de identidad completa")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                        }
                        .padding(.top, 50)
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: showContent)

                        // BARRA DE PROGRESO 100%
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Completado")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                                Spacer()

                                Text("100%")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                            }

                            // Barra de progreso totalmente llena
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    // Pista gris muy clara
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(red: 0.9, green: 0.88, blue: 0.95))
                                        .frame(height: 8)

                                    // Barra llena en lila
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(red: 0.7, green: 0.5, blue: 0.85),
                                                    Color(red: 0.8, green: 0.4, blue: 0.75)
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: geometry.size.width, height: 8)
                                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: showContent)
                                }
                            }
                            .frame(height: 8)
                            .accessibilityLabel("Progreso del registro: 100 por ciento completado")
                        }
                        .padding(.horizontal, 30)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeIn(duration: 0.4).delay(0.2), value: showContent)

                        // TARJETA BLANCA CON MENSAJE DE ÉXITO
                        VStack(spacing: 24) {
                            // Ícono de check circular en verde
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.2, green: 0.7, blue: 0.3))
                                    .frame(width: 100, height: 100)

                                Image(systemName: "checkmark")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
                            .accessibilityLabel("Ícono de verificación exitosa")

                            // Título grande
                            Text("¡Registro Completado!")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.3))

                            // Texto secundario en verde
                            Text("Tu identidad ha sido verificada exitosamente. Bienvenida a ASCENDIA.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 0.35))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)

                            // LISTA DE VERIFICACIÓN CON CHECKS VERDES
                            VStack(spacing: 14) {
                                VerificationItem(text: "Información personal verificada")
                                VerificationItem(text: "Teléfono confirmado")
                                VerificationItem(text: "INE validada")
                                VerificationItem(text: "Identidad facial confirmada")
                            }
                            .padding(.top, 8)
                            .accessibilityLabel("Lista de elementos verificados")

                            // BADGE "PERFIL VERIFICADO"
                            HStack(spacing: 8) {
                                Image(systemName: "shield.checkmark.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.3))

                                Text("Perfil Verificado")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.3))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.9, green: 0.98, blue: 0.92))
                            .cornerRadius(20)
                            .accessibilityLabel("Insignia de perfil verificado")
                            .padding(.top, 4)

                            // BOTÓN PRIMARIO CON DEGRADADO
                            Button(action: {
                                navigateToHome = true

                                #if os(iOS)
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                #endif
                            }) {
                                Text("Acceder a ASCENDIA")
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
                                    .cornerRadius(16)
                                    .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .accessibilityLabel("Botón acceder a ASCENDIA")
                            .accessibilityHint("Toca para ir a la pantalla principal de la aplicación")
                            .padding(.top, 8)
                        }
                        .padding(28)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: Color.green.opacity(0.12), radius: 20, x: 0, y: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.6, green: 0.9, blue: 0.7), lineWidth: 1.5)
                        )
                        .padding(.horizontal, 30)
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.9)
                        .animation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.4), value: showContent)

                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
        .onAppear {
            // Activar animaciones de entrada
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showContent = true
            }
        }
    }
}

// MARK: - Verification Item Component

struct VerificationItem: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            // Check verde a la izquierda
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.3))
                .accessibilityLabel("Verificado")

            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(text) verificado")
    }
}

#Preview {
    RegistroCompletadoView()
}
