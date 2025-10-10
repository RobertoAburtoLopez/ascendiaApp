//
//  FacialRecognitionView.swift
//  ascendiaApp
//
//  Created by Roberto Aburto on 09/10/25.
//

import SwiftUI
// import AVFoundation // Temporalmente comentado para preview

struct FacialRecognitionView: View {
    // Estados
    @State private var isCapturing = false
    @State private var captureError = ""
    @State private var progressWidth: CGFloat = 0.9
    @State private var showSuccessNavigation = false

    var isPreview: Bool = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
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
                            Text("Reconocimiento Facial")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            Spacer()

                            Text("90%")
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
                        .accessibilityLabel("Progreso del registro: 90 por ciento")
                    }
                    .padding(.horizontal, 30)

                    // Tarjeta blanca con reconocimiento facial
                    VStack(spacing: 24) {
                        // Ícono de cámara
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.95, green: 0.92, blue: 0.98))
                                .frame(width: 100, height: 100)

                            Image(systemName: "camera.fill")
                                .font(.system(size: 45))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        }
                        .accessibilityLabel("Ícono de cámara")

                        // Encabezado
                        Text("Reconocimiento Facial")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        // Texto auxiliar
                        Text("Tomaremos una foto para verificar que coincidas con tu INE")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)

                        // Vista previa de cámara (placeholder temporal)
                        ZStack {
                            // Fondo oscuro
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.06, green: 0.06, blue: 0.1))
                                .frame(height: 380)

                            // Placeholder para preview (temporalmente siempre visible)
                            Color(red: 0.1, green: 0.1, blue: 0.15)
                                .frame(height: 380)
                                .clipShape(RoundedRectangle(cornerRadius: 20))

                            // Overlay con guías
                            ZStack {
                                // Indicador de grabación
                                VStack {
                                    HStack {
                                        if isCapturing {
                                            HStack(spacing: 6) {
                                                Circle()
                                                    .fill(Color.red)
                                                    .frame(width: 8, height: 8)
                                                    .opacity(0.3)

                                                Text("Capturando...")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.black.opacity(0.6))
                                            .cornerRadius(12)
                                        }

                                        Spacer()
                                    }
                                    .padding(16)

                                    Spacer()
                                }

                                // Círculo guía para el rostro
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .frame(width: 220, height: 220)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.4), lineWidth: 2)
                        )
                        .accessibilityLabel("Vista previa de cámara para reconocimiento facial")

                        // Mensaje de error
                        if !captureError.isEmpty {
                            Text(captureError)
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .transition(.opacity)
                        }

                        // Tarjeta de instrucciones
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instrucciones:")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.3))

                            VStack(alignment: .leading, spacing: 6) {
                                InstructionRow(text: "Coloca tu rostro en el círculo")
                                InstructionRow(text: "Mantén los ojos abiertos")
                                InstructionRow(text: "No uses lentes oscuros")
                                InstructionRow(text: "Asegúrate de tener buena luz")
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 0.9, green: 0.98, blue: 0.92))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.6, green: 0.9, blue: 0.7), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .accessibilityLabel("Instrucciones para el reconocimiento facial")

                        // Botón Iniciar Verificación
                        Button(action: {
                            startVerification()
                        }) {
                            HStack(spacing: 12) {
                                if isCapturing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))

                                    Text("Verificando...")
                                        .font(.system(size: 17, weight: .semibold))
                                } else {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 18))

                                    Text("Iniciar Verificación")
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
                        .disabled(isCapturing)
                        .opacity(isCapturing ? 0.5 : 1.0)
                        .accessibilityLabel("Botón iniciar verificación facial")
                        .accessibilityHint("Toca para iniciar la verificación facial")
                        .padding(.top, 8)

                        // Botón repetir (solo si hay error)
                        if !captureError.isEmpty && !isCapturing {
                            Button(action: {
                                retryCapture()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 15))

                                    Text("Intentar de nuevo")
                                        .font(.system(size: 15, weight: .medium))
                                }
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                            }
                            .accessibilityLabel("Botón reintentar verificación")
                            .transition(.opacity)
                        }
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
                    if !isCapturing {
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
                    } else {
                        Spacer()
                            .frame(height: 40)
                    }
                    }
                }
            }
            .navigationDestination(isPresented: $showSuccessNavigation) {
                RegistroCompletadoView()
            }
            .onAppear {
                // Iniciar desde 75%
                progressWidth = 0.75

                // Animar a 90% después de un breve momento
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    progressWidth = 0.9
                }
            }
        }
    }

    // MARK: - Funciones

    private func startVerification() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif

        withAnimation {
            isCapturing = true
            captureError = ""
        }

        // Simular captura y procesamiento (solo frontend)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isCapturing = false

                #if os(iOS)
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
                #endif

                // Simulación exitosa siempre
                print("✅ Reconocimiento facial exitoso (simulado)")
                showSuccessNavigation = true
            }
        }
    }

    private func retryCapture() {
        withAnimation {
            captureError = ""
        }

        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Camera Manager (Temporalmente comentado)

// class CameraManager: NSObject, ObservableObject {
//     @Published var isAuthorized = false
//     @Published var isRecording = false
//     @Published var session = AVCaptureSession()
//     @Published var preview = AVCaptureVideoPreviewLayer()
//
//     override init() {
//         super.init()
//     }
//
//     func requestPermission(completion: @escaping (Bool) -> Void) {
//         switch AVCaptureDevice.authorizationStatus(for: .video) {
//         case .authorized:
//             isAuthorized = true
//             setupCamera()
//             completion(true)
//         case .notDetermined:
//             AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
//                 DispatchQueue.main.async {
//                     self?.isAuthorized = granted
//                     if granted {
//                         self?.setupCamera()
//                     }
//                     completion(granted)
//                 }
//             }
//         case .denied, .restricted:
//             isAuthorized = false
//             completion(false)
//         @unknown default:
//             isAuthorized = false
//             completion(false)
//         }
//     }
//
//     private func setupCamera() {
//         do {
//             session.beginConfiguration()
//
//             guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//                 return
//             }
//
//             let input = try AVCaptureDeviceInput(device: device)
//
//             if session.canAddInput(input) {
//                 session.addInput(input)
//             }
//
//             session.commitConfiguration()
//
//             DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                 self?.session.startRunning()
//             }
//         } catch {
//             print("Error setting up camera: \(error.localizedDescription)")
//         }
//     }
//
//     func stopCamera() {
//         session.stopRunning()
//     }
// }

// MARK: - Facial Camera Preview (Temporalmente comentado)

// #if os(iOS)
// struct FacialCameraPreview: UIViewRepresentable {
//     @ObservedObject var cameraManager: CameraManager
//
//     func makeUIView(context: Context) -> UIView {
//         let view = UIView(frame: .zero)
//
//         cameraManager.preview = AVCaptureVideoPreviewLayer(session: cameraManager.session)
//         cameraManager.preview.frame = view.bounds
//         cameraManager.preview.videoGravity = .resizeAspectFill
//         view.layer.addSublayer(cameraManager.preview)
//
//         return view
//     }
//
//     func updateUIView(_ uiView: UIView, context: Context) {
//         DispatchQueue.main.async {
//             cameraManager.preview.frame = uiView.bounds
//         }
//     }
// }
// #else
// struct FacialCameraPreview: View {
//     @ObservedObject var cameraManager: CameraManager
//
//     var body: some View {
//         Rectangle()
//             .fill(Color.black)
//     }
// }
// #endif

// MARK: - Instruction Row Component

struct InstructionRow: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(red: 0.2, green: 0.6, blue: 0.3))
                .frame(width: 6, height: 6)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }
}

#Preview {
    FacialRecognitionView(isPreview: true)
}
