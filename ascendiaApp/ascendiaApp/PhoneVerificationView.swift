//
//  PhoneVerificationView.swift
//  ascendiaApp
//
//  Created by Roberto Aburto on 08/10/25.
//

import SwiftUI

struct PhoneVerificationView: View {
    let phoneNumber: String

    // Estados del código
    @State private var digit1 = ""
    @State private var digit2 = ""
    @State private var digit3 = ""
    @State private var digit4 = ""
    @State private var digit5 = ""
    @State private var digit6 = ""

    // Estados de UI
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showToast = false
    @State private var shakeOffset: CGFloat = 0
    @State private var progressWidth: CGFloat = 0.5
    @State private var showINEVerification = false

    // Timer para reenvío
    @State private var canResend = false
    @State private var secondsRemaining = 30
    @State private var timer: Timer?

    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Int?

    // Código completo
    var verificationCode: String {
        digit1 + digit2 + digit3 + digit4 + digit5 + digit6
    }

    var isCodeComplete: Bool {
        verificationCode.count == 6
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
                            Text("Verificación Telefónica")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            Spacer()

                            Text("50%")
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
                        .accessibilityLabel("Progreso del registro: 50 por ciento")
                    }
                    .padding(.horizontal, 30)

                    // Tarjeta blanca con formulario
                    VStack(spacing: 24) {
                        // Ícono de teléfono grande
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.95, green: 0.92, blue: 0.98))
                                .frame(width: 100, height: 100)

                            Image(systemName: "phone.fill")
                                .font(.system(size: 45))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        }
                        .accessibilityLabel("Ícono de teléfono")

                        // Encabezado
                        Text("Verificación Telefónica")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        // Texto auxiliar
                        Text("Enviaremos un código SMS al número")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)

                        Text(phoneNumber.isEmpty ? "+52 81 1234 5678" : phoneNumber)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        // Campo de código de 6 dígitos
                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                DigitField(text: $digit1, focusedField: $focusedField, index: 0, nextIndex: 1, showError: showError)
                                DigitField(text: $digit2, focusedField: $focusedField, index: 1, nextIndex: 2, showError: showError)
                                DigitField(text: $digit3, focusedField: $focusedField, index: 2, nextIndex: 3, showError: showError)
                                DigitField(text: $digit4, focusedField: $focusedField, index: 3, nextIndex: 4, showError: showError)
                                DigitField(text: $digit5, focusedField: $focusedField, index: 4, nextIndex: 5, showError: showError)
                                DigitField(text: $digit6, focusedField: $focusedField, index: 5, nextIndex: nil, showError: showError)
                            }
                            .offset(x: shakeOffset)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Campo de código de verificación de 6 dígitos")

                            // Mensaje de error
                            if showError {
                                Text(errorMessage)
                                    .font(.system(size: 13))
                                    .foregroundColor(.red)
                                    .transition(.opacity)
                            }
                        }
                        .padding(.top, 8)

                        // Botón Verificar Código
                        Button(action: {
                            verifyCode()
                        }) {
                            HStack(spacing: 12) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Verificar Código")
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
                        .disabled(!isCodeComplete || isLoading)
                        .opacity((isCodeComplete && !isLoading) ? 1.0 : 0.5)
                        .accessibilityLabel("Botón verificar código")
                        .accessibilityHint(isCodeComplete ? "Toca para verificar el código" : "Ingresa los 6 dígitos para continuar")
                        .padding(.top, 8)

                        // Botón Reenviar código
                        Button(action: {
                            resendCode()
                        }) {
                            Text(canResend ? "Reenviar código" : "Reenviar en \(secondsRemaining)s")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(canResend ? Color(red: 0.6, green: 0.4, blue: 0.8) : .gray)
                        }
                        .disabled(!canResend)
                        .accessibilityLabel(canResend ? "Reenviar código" : "Reenviar código en \(secondsRemaining) segundos")
                        .accessibilityHint("Toca para solicitar un nuevo código")
                    }
                    .padding(32)
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

            // Toast de confirmación
            if showToast {
                VStack {
                    Spacer()

                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text("Código reenviado")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.8))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 50)
                }
                .accessibilityLabel("Código reenviado exitosamente")
            }
        }
        .onAppear {
            // Iniciar desde 25%
            progressWidth = 0.25

            // Animar a 50% después de un breve momento
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                progressWidth = 0.5
            }

            startTimer()
            // Auto-focus en el primer campo
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = 0
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .onChange(of: digit1) { _, newValue in
            handleDigitChange(newValue, index: 0, binding: $digit1, nextIndex: 1)
        }
        .onChange(of: digit2) { _, newValue in
            handleDigitChange(newValue, index: 1, binding: $digit2, nextIndex: 2)
        }
        .onChange(of: digit3) { _, newValue in
            handleDigitChange(newValue, index: 2, binding: $digit3, nextIndex: 3)
        }
        .onChange(of: digit4) { _, newValue in
            handleDigitChange(newValue, index: 3, binding: $digit4, nextIndex: 4)
        }
        .onChange(of: digit5) { _, newValue in
            handleDigitChange(newValue, index: 4, binding: $digit5, nextIndex: 5)
        }
        .onChange(of: digit6) { _, newValue in
            handleDigitChange(newValue, index: 5, binding: $digit6, nextIndex: nil)
        }
        .fullScreenCover(isPresented: $showINEVerification) {
            INEVerificationView()
        }
    }

    // MARK: - Funciones

    private func handleDigitChange(_ newValue: String, index: Int, binding: Binding<String>, nextIndex: Int?) {
        // Solo permitir dígitos
        let filtered = newValue.filter { $0.isNumber }

        if filtered.count > 1 {
            // Si se pega un código completo
            let digits = Array(filtered.prefix(6))
            if digits.count >= 1 { digit1 = String(digits[0]) }
            if digits.count >= 2 { digit2 = String(digits[1]) }
            if digits.count >= 3 { digit3 = String(digits[2]) }
            if digits.count >= 4 { digit4 = String(digits[3]) }
            if digits.count >= 5 { digit5 = String(digits[4]) }
            if digits.count == 6 { digit6 = String(digits[5]) }
            focusedField = nil
        } else {
            binding.wrappedValue = filtered

            // Auto-avanzar al siguiente campo
            if !filtered.isEmpty, let next = nextIndex {
                focusedField = next
            }
        }

        // Limpiar error al escribir
        if showError {
            showError = false
        }
    }

    private func verifyCode() {
        #if os(iOS)
        // Feedback háptico
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif

        isLoading = true

        // Simular verificación
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false

            // Aceptar cualquier código de 6 dígitos por ahora
            if verificationCode.count == 6 {
                // Código correcto - continuar al siguiente paso
                #if os(iOS)
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
                #endif

                // Navegar a verificación INE
                print("✅ Código verificado: \(verificationCode)")

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showINEVerification = true
                }
            } else {
                showError = true
                errorMessage = "Código incorrecto. Intenta de nuevo."
                shakeAnimation()

                #if os(iOS)
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.error)
                #endif
            }
        }
    }

    private func resendCode() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif

        // Mostrar toast
        withAnimation {
            showToast = true
        }

        // Ocultar toast después de 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }

        // Reiniciar timer
        canResend = false
        secondsRemaining = 30
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                canResend = true
                timer?.invalidate()
            }
        }
    }

    private func shakeAnimation() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
            shakeOffset = 10
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
                shakeOffset = -10
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
                shakeOffset = 5
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
                shakeOffset = 0
            }
        }
    }
}

// MARK: - DigitField Component

struct DigitField: View {
    @Binding var text: String
    var focusedField: FocusState<Int?>.Binding
    let index: Int
    let nextIndex: Int?
    let showError: Bool

    var body: some View {
        TextField("", text: $text)
            .font(.system(size: 24, weight: .semibold, design: .monospaced))
            .multilineTextAlignment(.center)
            #if os(iOS)
            .keyboardType(.numberPad)
            #endif
            .textContentType(.oneTimeCode)
            .frame(width: 45, height: 55)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(showError ? Color.red : Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5), lineWidth: 2)
            )
            .cornerRadius(12)
            .focused(focusedField, equals: index)
            .accessibilityLabel("Dígito \(index + 1)")
    }
}

#Preview {
    PhoneVerificationView(phoneNumber: "+52 81 1234 5678")
}
