//
//  INEVerificationView.swift
//  ascendiaApp
//
//  Created by Roberto Aburto on 09/10/25.
//

import SwiftUI
import PhotosUI

struct INEVerificationView: View {
    // Estados de las imágenes
    @State private var frontImage: UIImage?
    @State private var backImage: UIImage?
    @State private var frontImageItem: PhotosPickerItem?
    @State private var backImageItem: PhotosPickerItem?

    // Estados de UI
    @State private var frontError = ""
    @State private var backError = ""
    @State private var isProcessing = false
    @State private var progressWidth: CGFloat = 0.75
    @State private var showImagePicker = false
    @State private var selectedSide: INESide?
    @State private var showFacialRecognition = false

    @Environment(\.dismiss) var dismiss

    enum INESide {
        case front, back
    }

    var isFormValid: Bool {
        frontImage != nil && backImage != nil
    }

    var body: some View {
        ZStack {
            // Fondo con degradado suave en lilas/rosas
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
                    // Header con ícono de escudo
                    VStack(spacing: 12) {
                        // Ícono redondeado con escudo
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

                    // Barra de progreso
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Verificación INE")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            Spacer()

                            Text("75%")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        }

                        // Barra de progreso
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 0.9, green: 0.88, blue: 0.95))
                                    .frame(height: 8)

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
                                    .frame(width: geometry.size.width * progressWidth, height: 8)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progressWidth)
                            }
                        }
                        .frame(height: 8)
                        .accessibilityLabel("Progreso del registro: 75 por ciento")
                    }
                    .padding(.horizontal, 30)

                    // Tarjeta blanca con verificación INE
                    VStack(spacing: 24) {
                        // Ícono de credencial
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.95, green: 0.92, blue: 0.98))
                                .frame(width: 100, height: 100)

                            Image(systemName: "creditcard")
                                .font(.system(size: 45))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        }
                        .accessibilityLabel("Ícono de credencial")

                        // Encabezado
                        Text("Verificación de INE")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        // Texto auxiliar
                        Text("Sube fotos claras del frente y reverso de tu credencial de elector")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)

                        // Zona de carga - Frente de la INE
                        VStack(spacing: 8) {
                            PhotosPicker(selection: $frontImageItem, matching: .images) {
                                INEDropZone(
                                    title: "Frente de la INE",
                                    subtitle: "Toca para subir imagen",
                                    image: frontImage,
                                    hasError: !frontError.isEmpty
                                )
                            }
                            .onChange(of: frontImageItem) { _, newItem in
                                loadImage(from: newItem, for: .front)
                            }
                            .accessibilityLabel("Zona de carga del frente de la INE")
                            .accessibilityHint("Toca para seleccionar una imagen del frente de tu INE")

                            if !frontError.isEmpty {
                                Text(frontError)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }

                        // Zona de carga - Reverso de la INE
                        VStack(spacing: 8) {
                            PhotosPicker(selection: $backImageItem, matching: .images) {
                                INEDropZone(
                                    title: "Reverso de la INE",
                                    subtitle: "Toca para subir imagen",
                                    image: backImage,
                                    hasError: !backError.isEmpty
                                )
                            }
                            .onChange(of: backImageItem) { _, newItem in
                                loadImage(from: newItem, for: .back)
                            }
                            .accessibilityLabel("Zona de carga del reverso de la INE")
                            .accessibilityHint("Toca para seleccionar una imagen del reverso de tu INE")

                            if !backError.isEmpty {
                                Text(backError)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }

                        // Recuadro informativo
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Requisitos:")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

                                    VStack(alignment: .leading, spacing: 6) {
                                        RequirementRow(text: "INE vigente y legible")
                                        RequirementRow(text: "Buena iluminación")
                                        RequirementRow(text: "Sin reflejos ni sombras")
                                        RequirementRow(text: "Información completamente visible")
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(red: 0.9, green: 0.95, blue: 1.0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.6, green: 0.8, blue: 1.0), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .accessibilityLabel("Requisitos para la foto de INE")

                        // Botón Procesar Documentos
                        Button(action: {
                            processDocuments()
                        }) {
                            HStack(spacing: 12) {
                                if isProcessing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18))

                                    Text("Procesar Documentos")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
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
                        .disabled(!isFormValid || isProcessing)
                        .opacity((isFormValid && !isProcessing) ? 1.0 : 0.5)
                        .accessibilityLabel("Botón procesar documentos")
                        .accessibilityHint(isFormValid ? "Toca para procesar y verificar tus documentos" : "Sube ambas imágenes para continuar")
                        .padding(.top, 8)
                    }
                    .padding(28)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.15), radius: 20, x: 0, y: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 30)

                    // Botón volver
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Volver")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    }
                    .accessibilityLabel("Botón volver")
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            // Iniciar desde 50%
            progressWidth = 0.5

            // Animar a 75% después de un breve momento
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                progressWidth = 0.75
            }
        }
        .fullScreenCover(isPresented: $showFacialRecognition) {
            FacialRecognitionView()
        }
    }

    // MARK: - Funciones

    private func loadImage(from item: PhotosPickerItem?, for side: INESide) {
        guard let item = item else { return }

        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        switch side {
                        case .front:
                            frontImage = image
                            frontError = ""
                            #if os(iOS)
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            #endif
                        case .back:
                            backImage = image
                            backError = ""
                            #if os(iOS)
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            #endif
                        }
                    }
                } else {
                    await MainActor.run {
                        setError(for: side, message: "No se pudo cargar la imagen")
                    }
                }
            } catch {
                await MainActor.run {
                    setError(for: side, message: "Error al cargar la imagen")
                }
            }
        }
    }

    private func setError(for side: INESide, message: String) {
        switch side {
        case .front:
            frontError = message
        case .back:
            backError = message
        }
    }

    private func processDocuments() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif

        isProcessing = true
        frontError = ""
        backError = ""

        // Simular procesamiento
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false

            #if os(iOS)
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
            #endif

            // Navegar a verificación facial
            showFacialRecognition = true
        }
    }
}

// MARK: - INE Drop Zone Component

struct INEDropZone: View {
    let title: String
    let subtitle: String
    let image: UIImage?
    let hasError: Bool

    var body: some View {
        ZStack {
            if let image = image {
                // Mostrar miniatura de la imagen
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.7, green: 0.5, blue: 0.85), lineWidth: 2)
                    )
            } else {
                // Zona de carga vacía
                VStack(spacing: 12) {
                    Image(systemName: "arrow.up.doc")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))

                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .background(Color(red: 0.98, green: 0.96, blue: 1.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            hasError ? Color.red : Color(red: 0.7, green: 0.5, blue: 0.85),
                            style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                        )
                )
                .cornerRadius(16)
            }
        }
    }
}

// MARK: - Requirement Row Component

struct RequirementRow: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(red: 0.2, green: 0.5, blue: 0.8))
                .frame(width: 6, height: 6)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }
}

#Preview {
    INEVerificationView()
}
