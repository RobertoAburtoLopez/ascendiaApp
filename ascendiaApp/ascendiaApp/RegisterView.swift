//
//  RegisterView.swift
//  ascendiaApp
//
//  Created by Roberto Aburto  on 08/10/25.
//

import SwiftUI

struct RegisterView: View {
    // Estados del formulario
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var countryCode = "+52"
    @State private var birthDate = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    // Estados de UI
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @State private var showPhoneVerification = false
    @State private var showCountryPicker = false

    // Estados de error
    @State private var emailError = ""
    @State private var phoneError = ""
    @State private var passwordError = ""
    @State private var confirmPasswordError = ""

    @Environment(\.dismiss) var dismiss

    // Lista de códigos de país
    let countryCodes = [
        ("🇲🇽", "+52", "México"),
        ("🇺🇸", "+1", "Estados Unidos"),
        ("🇨🇦", "+1", "Canadá"),
        ("🇪🇸", "+34", "España"),
        ("🇦🇷", "+54", "Argentina"),
        ("🇨🇴", "+57", "Colombia"),
        ("🇨🇱", "+56", "Chile"),
        ("🇵🇪", "+51", "Perú"),
        ("🇻🇪", "+58", "Venezuela"),
        ("🇪🇨", "+593", "Ecuador"),
        ("🇧🇷", "+55", "Brasil"),
        ("🇺🇾", "+598", "Uruguay"),
        ("🇵🇾", "+595", "Paraguay"),
        ("🇧🇴", "+591", "Bolivia"),
        ("🇨🇷", "+506", "Costa Rica"),
        ("🇵🇦", "+507", "Panamá"),
        ("🇬🇹", "+502", "Guatemala"),
        ("🇸🇻", "+503", "El Salvador"),
        ("🇭🇳", "+504", "Honduras"),
        ("🇳🇮", "+505", "Nicaragua")
    ]

    // Validación del formulario
    var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        emailError.isEmpty &&
        isValidEmail(email) &&
        !phone.isEmpty &&
        !birthDate.isEmpty &&
        !password.isEmpty &&
        password.count >= 8 &&
        !confirmPassword.isEmpty &&
        password == confirmPassword
    }

    // Validación de email con regex
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
                            Text("Información Básica")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                            Spacer()

                            Text("25%")
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
                                    .frame(width: geometry.size.width * 0.25, height: 8)
                            }
                        }
                        .frame(height: 8)
                        .accessibilityLabel("Progreso del registro: 25 por ciento")
                    }
                    .padding(.horizontal, 30)

                    // Tarjeta blanca con formulario
                    VStack(spacing: 24) {
                        // Encabezado de la tarjeta
                        Text("Información Personal")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Nombre y Apellidos en dos columnas
                        HStack(spacing: 12) {
                            // Campo Nombre
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                        .frame(width: 20)

                                    TextField("María", text: $firstName)
                                        .textContentType(.givenName)
                                        #if os(iOS)
                                        .autocapitalization(.words)
                                        #endif
                                        .accessibilityLabel("Campo de nombre")
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5), lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                            }

                            // Campo Apellidos
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                        .frame(width: 20)

                                    TextField("González", text: $lastName)
                                        .textContentType(.familyName)
                                        #if os(iOS)
                                        .autocapitalization(.words)
                                        #endif
                                        .accessibilityLabel("Campo de apellidos")
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5), lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                            }
                        }

                        // Campo Correo Electrónico
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                    .frame(width: 20)

                                TextField("maria@email.com", text: $email)
                                    #if os(iOS)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    #endif
                                    .textContentType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .accessibilityLabel("Campo de correo electrónico")
                                    .onChange(of: email) { _, newValue in
                                        validateEmail(newValue)
                                    }
                                    .onSubmit {
                                        validateEmail(email)
                                    }
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(emailError.isEmpty ? Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5) : Color.red, lineWidth: 1.5)
                            )
                            .cornerRadius(12)

                            if !emailError.isEmpty {
                                Text(emailError)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }

                        // Campo Teléfono
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                    .frame(width: 20)

                                HStack(spacing: 8) {
                                    // Botón selector de código de país
                                    Button(action: {
                                        showCountryPicker = true
                                    }) {
                                        HStack(spacing: 4) {
                                            Text(countryCodes.first(where: { $0.1 == countryCode })?.0 ?? "🇲🇽")
                                                .font(.system(size: 20))
                                            Text(countryCode)
                                                .font(.system(size: 15))
                                                .foregroundColor(.primary)
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 10)
                                        .background(Color(red: 0.95, green: 0.92, blue: 0.98))
                                        .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    // Campo de número
                                    ZStack(alignment: .leading) {
                                        // Placeholder
                                        if phone.isEmpty {
                                            Text("81 1234 5678")
                                                .foregroundColor(.gray.opacity(0.6))
                                        }

                                        // TextField invisible para capturar input
                                        TextField("", text: $phone)
                                            #if os(iOS)
                                            .keyboardType(.numberPad)
                                            #endif
                                            .textContentType(.telephoneNumber)
                                            .accessibilityLabel("Campo de teléfono")
                                            .onChange(of: phone) { oldValue, newValue in
                                                formatPhoneNumber(newValue)
                                            }
                                            .foregroundColor(.clear)
                                            .accentColor(.clear)

                                        // Texto formateado visible
                                        if !phone.isEmpty {
                                            Text(formattedPhone)
                                                .foregroundColor(.primary)
                                                .allowsHitTesting(false)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(phoneError.isEmpty ? Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5) : Color.red, lineWidth: 1.5)
                            )
                            .cornerRadius(12)

                            if !phoneError.isEmpty {
                                Text(phoneError)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }

                        // Campo Fecha de Nacimiento
                        VStack(alignment: .leading, spacing: 6) {
                            Button(action: {
                                showDatePicker = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                        .frame(width: 20)

                                    Text(birthDate.isEmpty ? "08/10/2025" : birthDate)
                                        .foregroundColor(birthDate.isEmpty ? .gray.opacity(0.6) : .primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5), lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                            }
                            .accessibilityLabel("Campo de fecha de nacimiento")
                            .accessibilityHint("Toca para seleccionar tu fecha de nacimiento")
                        }

                        // Campo Contraseña
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                    .frame(width: 20)

                                if isPasswordVisible {
                                    TextField("", text: $password)
                                        .textContentType(.newPassword)
                                        .accessibilityLabel("Campo de contraseña")
                                        .onChange(of: password) { _, newValue in
                                            validatePassword(newValue)
                                        }
                                } else {
                                    SecureField("", text: $password)
                                        .textContentType(.newPassword)
                                        .accessibilityLabel("Campo de contraseña")
                                        .onChange(of: password) { _, newValue in
                                            validatePassword(newValue)
                                        }
                                }

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                }
                                .accessibilityLabel(isPasswordVisible ? "Ocultar contraseña" : "Mostrar contraseña")
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(passwordError.isEmpty ? Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5) : Color.red, lineWidth: 1.5)
                            )
                            .cornerRadius(12)

                            if !passwordError.isEmpty {
                                Text(passwordError)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }

                        // Campo Confirmar Contraseña
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                    .frame(width: 20)

                                if isConfirmPasswordVisible {
                                    TextField("", text: $confirmPassword)
                                        .textContentType(.newPassword)
                                        .accessibilityLabel("Campo de confirmar contraseña")
                                        .onChange(of: confirmPassword) { _, newValue in
                                            validateConfirmPassword(newValue)
                                        }
                                } else {
                                    SecureField("", text: $confirmPassword)
                                        .textContentType(.newPassword)
                                        .accessibilityLabel("Campo de confirmar contraseña")
                                        .onChange(of: confirmPassword) { _, newValue in
                                            validateConfirmPassword(newValue)
                                        }
                                }

                                Button(action: {
                                    isConfirmPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.85))
                                }
                                .accessibilityLabel(isConfirmPasswordVisible ? "Ocultar confirmación de contraseña" : "Mostrar confirmación de contraseña")
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(confirmPasswordError.isEmpty ? Color(red: 0.7, green: 0.5, blue: 0.85).opacity(0.5) : Color.red, lineWidth: 1.5)
                            )
                            .cornerRadius(12)

                            if !confirmPasswordError.isEmpty {
                                Text(confirmPasswordError)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }

                        // Botón Continuar
                        Button(action: {
                            #if os(iOS)
                            // Feedback háptico
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            #endif

                            // Validar todo antes de continuar
                            validateAllFields()

                            // Si todo es válido, navegar a verificación telefónica
                            if isFormValid {
                                showPhoneVerification = true
                            }
                        }) {
                            Text("Continuar")
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
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.5)
                        .accessibilityLabel("Botón continuar")
                        .accessibilityHint(isFormValid ? "Toca para continuar con el registro" : "Completa todos los campos para continuar")
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

                    // Footer - ¿Ya tienes cuenta?
                    VStack(spacing: 15) {
                        Text("¿Ya tienes una cuenta?")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        Button(action: {
                            dismiss()
                        }) {
                            Text("Iniciar sesión")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.95, green: 0.92, blue: 0.98))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.7, green: 0.5, blue: 0.85), lineWidth: 2)
                                )
                                .cornerRadius(12)
                        }
                        .accessibilityLabel("Botón de iniciar sesión")
                        .accessibilityHint("Toca para volver a la pantalla de inicio de sesión")
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .fullScreenCover(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate, birthDate: $birthDate)
        }
        .fullScreenCover(isPresented: $showCountryPicker) {
            CountryCodePickerSheet(selectedCountryCode: $countryCode, countryCodes: countryCodes)
        }
        .fullScreenCover(isPresented: $showPhoneVerification) {
            PhoneVerificationView(phoneNumber: fullPhoneNumber)
        }
    }

    // MARK: - Funciones de Formateo

    private func formatPhoneNumber(_ input: String) {
        // Filtrar solo números
        let digitsOnly = input.filter { $0.isNumber }

        // Limitar a 10 dígitos máximo y actualizar
        phone = String(digitsOnly.prefix(10))
    }

    // Computed property para mostrar el teléfono formateado
    private var formattedPhone: String {
        guard !phone.isEmpty else { return "" }

        let count = phone.count

        // Formato para México (+52): 81 1234 5678
        if countryCode == "+52" {
            var formatted = ""

            if count > 0 {
                formatted += String(phone.prefix(min(2, count)))
            }

            if count > 2 {
                let start = phone.index(phone.startIndex, offsetBy: 2)
                let end = phone.index(phone.startIndex, offsetBy: min(6, count))
                formatted += " " + String(phone[start..<end])
            }

            if count > 6 {
                let start = phone.index(phone.startIndex, offsetBy: 6)
                formatted += " " + String(phone[start...])
            }

            return formatted
        }
        // Formato genérico para otros países
        else {
            var formatted = ""
            let chunks = stride(from: 0, to: count, by: 3).map { index -> String in
                let start = phone.index(phone.startIndex, offsetBy: index)
                let end = phone.index(start, offsetBy: min(3, count - index))
                return String(phone[start..<end])
            }
            return chunks.joined(separator: " ")
        }
    }

    // Computed property para el número completo con código
    private var fullPhoneNumber: String {
        guard !phone.isEmpty else { return "" }
        return countryCode + " " + formattedPhone
    }

    // MARK: - Funciones de Validación

    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = ""
            return
        }

        if !isValidEmail(email) {
            emailError = "Formato de correo inválido"
        } else {
            emailError = ""
        }
    }

    private func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordError = ""
            return
        }

        if password.count < 8 {
            passwordError = "Mínimo 8 caracteres"
        } else {
            passwordError = ""
        }

        // Re-validar confirmación si ya hay algo escrito
        if !confirmPassword.isEmpty {
            validateConfirmPassword(confirmPassword)
        }
    }

    private func validateConfirmPassword(_ confirmPass: String) {
        if confirmPass.isEmpty {
            confirmPasswordError = ""
            return
        }

        if confirmPass != password {
            confirmPasswordError = "Las contraseñas no coinciden"
        } else {
            confirmPasswordError = ""
        }
    }

    private func validateAllFields() {
        validateEmail(email)
        validatePassword(password)
        validateConfirmPassword(confirmPassword)
    }
}

// Sheet para el selector de código de país

struct CountryCodePickerSheet: View {
    @Binding var selectedCountryCode: String
    let countryCodes: [(String, String, String)]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(countryCodes, id: \.1) { country in
                    Button(action: {
                        selectedCountryCode = country.1
                        dismiss()
                    }) {
                        HStack {
                            Text(country.0)
                                .font(.system(size: 28))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(country.2)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)

                                Text(country.1)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            if selectedCountryCode == country.1 {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Código de País")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }
                #else
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }
                #endif
            }
        }
        #if os(iOS)
        .presentationDetents([.medium, .large])
        #endif
    }
}

// Sheet para el DatePicker
struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var birthDate: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Fecha de Nacimiento",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                #if os(iOS)
                .datePickerStyle(.wheel)
                #else
                .datePickerStyle(.graphical)
                #endif
                .labelsHidden()
                .padding()

                Spacer()
            }
            .navigationTitle("Fecha de Nacimiento")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy"
                        birthDate = formatter.string(from: selectedDate)
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }
                #else
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy"
                        birthDate = formatter.string(from: selectedDate)
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }
                #endif
            }
        }
        #if os(iOS)
        .presentationDetents([.medium])
        #endif
    }
}

#Preview {
    RegisterView()
}
