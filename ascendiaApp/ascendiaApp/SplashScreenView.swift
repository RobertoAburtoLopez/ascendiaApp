//
//  SplashScreenView.swift
//  ascendiaApp
//
//  Created by Roberto Aburto on 09/10/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0

    var body: some View {
        ZStack {
            // Fondo con degradado vertical púrpura a fucsia
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.48, green: 0.18, blue: 0.97), // #7B2FF7 - Púrpura intenso
                    Color(red: 0.95, green: 0.03, blue: 0.64)  // #F107A3 - Fucsia rosado
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .blur(radius: 1.5) // Ligera difuminación para suavidad

            VStack(spacing: 0) {
                Spacer()

                // Logotipo y contenido central
                VStack(spacing: 24) {
                    // Logo cuadrado con esquinas redondeadas
                    ZStack {
                        // Fondo del logo - negro/azul profundo
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.05, green: 0.05, blue: 0.15), // Azul profundo
                                        Color.black
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)

                        // Ícono con flecha ascendente y siluetas
                        VStack(spacing: 4) {
                            // Flecha ascendente
                            Image(systemName: "arrow.up")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.95, green: 0.03, blue: 0.64), // Magenta
                                            Color(red: 0.48, green: 0.18, blue: 0.97)  // Azul
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            // Siluetas femeninas (usando íconos de personas)
                            HStack(spacing: 6) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.95, green: 0.03, blue: 0.64)) // Magenta

                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.95)) // Lila

                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.95)) // Azul
                            }
                        }
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .accessibilityLabel("Logo de ASCENDIA")

                    // Nombre ASCENDIA
                    VStack(spacing: 16) {
                        Text("ASCENDIA")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(2)
                            .accessibilityAddTraits(.isHeader)

                        // Línea horizontal decorativa
                        Rectangle()
                            .fill(Color(red: 0.7, green: 0.5, blue: 0.95)) // Lila claro
                            .frame(width: 120, height: 2)
                            .cornerRadius(1)
                    }
                    .opacity(textOpacity)

                    // Subtítulo
                    Text("Tu red social segura")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(textOpacity)
                        .accessibilityLabel("Tu red social segura")
                }

                Spacer()

                // Indicadores de páginas (dots)
                HStack(spacing: 12) {
                    // Punto 1 - activo (lleno)
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)

                    // Punto 2 - inactivo
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 10, height: 10)

                    // Punto 3 - inactivo
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
                .opacity(textOpacity)
                .padding(.bottom, 60)
                .accessibilityLabel("Indicador de página: página 1 de 3")
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    // MARK: - Funciones de animación

    private func startAnimations() {
        // Animación del logo
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        // Animación del texto (con delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.6)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
