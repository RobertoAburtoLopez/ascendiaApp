//
//  ReservaCamionFlowView.swift
//  ascendiaApp
//
//  Created by Claude Code on 14/10/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

// MARK: - Main Flow View

struct ReservaCamionFlowView: View {
    let camion: CamionMundial
    @Environment(\.dismiss) var dismiss

    @State private var pasoActual: PasoReserva = .datosPersonales
    @State private var mostrarExito = false

    // Paso 1: Datos Personales
    @State private var nombreCompleto = ""
    @State private var telefono = ""
    @State private var correo = ""
    @State private var nombreError: String? = nil
    @State private var telefonoError: String? = nil
    @State private var correoError: String? = nil

    // Paso 2: Detalles de Reserva
    @State private var numeroReservaciones = 1
    @State private var tieneDiscapacidad = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Contenido principal
                ScrollView {
                    VStack(spacing: 20) {
                        // Alerta informativa
                        alertaServicioExclusivo

                        // Tarjeta resumen
                        tarjetaResumen

                        // Indicador de pasos
                        indicadorPasos

                        // Contenido según el paso
                        if pasoActual == .datosPersonales {
                            paso1DatosPersonales
                        } else {
                            paso2DetallesReserva
                        }

                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.vertical, 20)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.92, blue: 0.98),
                            Color(red: 0.98, green: 0.94, blue: 0.96)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

                // Botones flotantes en la parte inferior
                VStack {
                    Spacer()
                    botonesInferiores
                }
            }
            .navigationTitle("Reservar Camión")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    }
                }
            }
            .fullScreenCover(isPresented: $mostrarExito) {
                ReservaExitoView(
                    camion: camion,
                    nombreCompleto: nombreCompleto,
                    numeroReservaciones: numeroReservaciones,
                    onDismiss: {
                        mostrarExito = false
                        dismiss()
                    }
                )
            }
        }
    }

    // MARK: - Alerta Servicio Exclusivo

    private var alertaServicioExclusivo: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

            Text("Servicio exclusivo para mujeres y niños menores de 12 años")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                .lineSpacing(3)

            Spacer()
        }
        .padding(16)
        .background(Color(red: 0.95, green: 0.93, blue: 0.98))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.3), lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Información: Servicio exclusivo para mujeres y niños menores de 12 años")
    }

    // MARK: - Tarjeta Resumen

    private var tarjetaResumen: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Ruta (lado izquierdo)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ruta")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                    Text(rutaFormateada)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .lineSpacing(4)
                }

                Spacer()

                // Datos a la derecha
                VStack(alignment: .trailing, spacing: 8) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Salida")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        Text(camion.horaSalida)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    }

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Duración")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        Text(camion.duracionEstimada)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    }
                }
            }

            // Badge de asientos
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.3))

                Text("\(camion.asientosDisponibles) disponibles")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.3))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(red: 0.9, green: 0.98, blue: 0.92))
            .cornerRadius(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color(red: 0.98, green: 0.97, blue: 0.99)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.purple.opacity(0.15), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 20)
    }

    // MARK: - Indicador de Pasos

    private var indicadorPasos: some View {
        HStack(spacing: 12) {
            // Paso 1
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(pasoActual == .datosPersonales ? Color(red: 0.6, green: 0.4, blue: 0.8) : Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)

                    Text("1")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(pasoActual == .datosPersonales ? .white : .gray)
                }

                Text("Datos personales")
                    .font(.system(size: 12, weight: pasoActual == .datosPersonales ? .semibold : .regular))
                    .foregroundColor(pasoActual == .datosPersonales ? Color(red: 0.6, green: 0.4, blue: 0.8) : .gray)
            }
            .frame(maxWidth: .infinity)

            // Línea separadora
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 2)
                .padding(.bottom, 20)

            // Paso 2
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(pasoActual == .detallesReserva ? Color(red: 0.6, green: 0.4, blue: 0.8) : Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)

                    Text("2")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(pasoActual == .detallesReserva ? .white : .gray)
                }

                Text("Detalles de reserva")
                    .font(.system(size: 12, weight: pasoActual == .detallesReserva ? .semibold : .regular))
                    .foregroundColor(pasoActual == .detallesReserva ? Color(red: 0.6, green: 0.4, blue: 0.8) : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    // MARK: - Paso 1: Datos Personales

    private var paso1DatosPersonales: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Campo Nombre Completo
            VStack(alignment: .leading, spacing: 8) {
                Text("Nombre completo *")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                TextField("Ingresa tu nombre completo", text: $nombreCompleto)
                    .textContentType(.name)
                    #if os(iOS)
                    .textInputAutocapitalization(.words)
                    #endif
                    .autocorrectionDisabled()
                    .padding(16)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(nombreError != nil ? Color.red : Color.gray.opacity(0.3), lineWidth: 1.5)
                    )
                    .onChange(of: nombreCompleto) { _, _ in
                        validarNombre()
                    }
                    .accessibilityLabel("Nombre completo")
                    .accessibilityHint("Campo requerido")

                if let error = nombreError {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
            }

            // Campo Teléfono
            VStack(alignment: .leading, spacing: 8) {
                Text("Teléfono *")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                TextField("+52 ...", text: $telefono)
                    .textContentType(.telephoneNumber)
                    #if os(iOS)
                    .keyboardType(.phonePad)
                    #endif
                    .padding(16)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(telefonoError != nil ? Color.red : Color.gray.opacity(0.3), lineWidth: 1.5)
                    )
                    .onChange(of: telefono) { _, _ in
                        validarTelefono()
                    }
                    .accessibilityLabel("Teléfono")
                    .accessibilityHint("Campo requerido, ingresa tu número de teléfono")

                if let error = telefonoError {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
            }

            // Campo Correo Electrónico
            VStack(alignment: .leading, spacing: 8) {
                Text("Correo electrónico *")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                TextField("ejemplo@correo.com", text: $correo)
                    .textContentType(.emailAddress)
                    #if os(iOS)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()
                    .padding(16)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(correoError != nil ? Color.red : Color.gray.opacity(0.3), lineWidth: 1.5)
                    )
                    .onChange(of: correo) { _, _ in
                        validarCorreo()
                    }
                    .accessibilityLabel("Correo electrónico")
                    .accessibilityHint("Campo requerido")

                if let error = correoError {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .transition(.slide)
    }

    // MARK: - Paso 2: Detalles de Reserva

    private var paso2DetallesReserva: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Número de reservaciones
            VStack(alignment: .leading, spacing: 12) {
                Text("Número de reservaciones *")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                HStack {
                    Button(action: {
                        if numeroReservaciones > 1 {
                            numeroReservaciones -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(numeroReservaciones > 1 ? Color(red: 0.6, green: 0.4, blue: 0.8) : Color.gray.opacity(0.3))
                    }
                    .disabled(numeroReservaciones <= 1)

                    Spacer()

                    Text("\(numeroReservaciones)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        .frame(minWidth: 60)

                    Spacer()

                    Button(action: {
                        if numeroReservaciones < min(camion.asientosDisponibles, 8) {
                            numeroReservaciones += 1
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(numeroReservaciones < min(camion.asientosDisponibles, 8) ? Color(red: 0.6, green: 0.4, blue: 0.8) : Color.gray.opacity(0.3))
                    }
                    .disabled(numeroReservaciones >= min(camion.asientosDisponibles, 8))
                }
                .padding(.vertical, 8)

                Text("Máximo \(min(camion.asientosDisponibles, 8)) asientos disponibles")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)

            // Pregunta sobre discapacidad
            VStack(alignment: .leading, spacing: 12) {
                Text("¿Tienes alguna discapacidad?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                HStack(spacing: 12) {
                    // Botón No
                    Button(action: {
                        tieneDiscapacidad = false
                    }) {
                        Text("No")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(tieneDiscapacidad ? Color(red: 0.3, green: 0.3, blue: 0.3) : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                tieneDiscapacidad ? Color.white : Color(red: 0.6, green: 0.4, blue: 0.8)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                            )
                    }

                    // Botón Sí
                    Button(action: {
                        tieneDiscapacidad = true
                    }) {
                        Text("Sí")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(!tieneDiscapacidad ? Color(red: 0.3, green: 0.3, blue: 0.3) : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                !tieneDiscapacidad ? Color.white : Color(red: 0.6, green: 0.4, blue: 0.8)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                            )
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)

            // Tarjeta informativa
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.9))

                Text("Tu reservación será confirmada inmediatamente y recibirás los detalles por SMS y correo electrónico.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                    .lineSpacing(3)

                Spacer()
            }
            .padding(16)
            .background(Color(red: 0.93, green: 0.96, blue: 0.99))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.2, green: 0.5, blue: 0.9).opacity(0.3), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .transition(.slide)
    }

    // MARK: - Botones Inferiores

    private var botonesInferiores: some View {
        VStack(spacing: 12) {
            if pasoActual == .datosPersonales {
                // Botón Continuar (Paso 1)
                Button(action: {
                    withAnimation(.spring(response: 0.4)) {
                        pasoActual = .detallesReserva
                    }

                    #if os(iOS)
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    #endif
                }) {
                    Text("Continuar")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            formularioValido ?
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.6, green: 0.4, blue: 0.8),
                                    Color(red: 0.9, green: 0.2, blue: 0.6)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(
                            color: formularioValido ? Color.purple.opacity(0.3) : Color.clear,
                            radius: 10,
                            x: 0,
                            y: 5
                        )
                }
                .disabled(!formularioValido)
                .accessibilityLabel("Continuar al paso 2")
                .accessibilityHint(formularioValido ? "Completa los detalles de tu reserva" : "Completa todos los campos requeridos primero")
            } else {
                // Botones del Paso 2
                Button(action: {
                    #if os(iOS)
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                    #endif

                    mostrarExito = true
                }) {
                    Text("Confirmar Reservación")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
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
                        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .accessibilityLabel("Confirmar reservación")
                .accessibilityHint("Toca para completar tu reserva")

                Button(action: {
                    withAnimation(.spring(response: 0.4)) {
                        pasoActual = .datosPersonales
                    }

                    #if os(iOS)
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    #endif
                }) {
                    Text("Regresar")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 2)
                        )
                        .cornerRadius(14)
                }
                .accessibilityLabel("Regresar al paso anterior")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
    }

    // MARK: - Computed Properties

    private var rutaFormateada: String {
        if camion.ruta.paradas.isEmpty {
            return "\(camion.ruta.origen) → \(camion.ruta.destino.estadio)"
        } else {
            let paradasTexto = camion.ruta.paradas.map { $0.nombre }.joined(separator: " → ")
            return "\(camion.ruta.origen) → \(paradasTexto) → \(camion.ruta.destino.estadio)"
        }
    }

    private var formularioValido: Bool {
        return !nombreCompleto.isEmpty &&
               nombreError == nil &&
               !telefono.isEmpty &&
               telefonoError == nil &&
               !correo.isEmpty &&
               correoError == nil
    }

    // MARK: - Validaciones

    private func validarNombre() {
        if nombreCompleto.isEmpty {
            nombreError = "El nombre es requerido"
        } else if nombreCompleto.count < 3 {
            nombreError = "El nombre debe tener al menos 3 caracteres"
        } else {
            nombreError = nil
        }
    }

    private func validarTelefono() {
        if telefono.isEmpty {
            telefonoError = "El teléfono es requerido"
        } else if telefono.count < 10 {
            telefonoError = "Ingresa un número de teléfono válido"
        } else {
            telefonoError = nil
        }
    }

    private func validarCorreo() {
        if correo.isEmpty {
            correoError = "El correo es requerido"
        } else if !correo.contains("@") || !correo.contains(".") {
            correoError = "Ingresa un correo válido"
        } else {
            correoError = nil
        }
    }
}

// MARK: - Paso Enum

enum PasoReserva {
    case datosPersonales
    case detallesReserva
}

// MARK: - Vista de Éxito con QR

struct ReservaExitoView: View {
    let camion: CamionMundial
    let nombreCompleto: String
    let numeroReservaciones: Int
    let onDismiss: () -> Void

    @State private var reservaID = UUID().uuidString.prefix(8).uppercased()

    var body: some View {
        ZStack {
            // Fondo con degradado
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.92, blue: 0.98),
                    Color(red: 0.98, green: 0.94, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Ícono de éxito
                ZStack {
                    Circle()
                        .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.green.opacity(0.3), radius: 20, x: 0, y: 10)

                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: true)

                // Título
                Text("¡Reservación Exitosa!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .multilineTextAlignment(.center)

                // QR Code
                VStack(spacing: 16) {
                    if let qrImage = generarQRCode(texto: "ASCENDIA-\(reservaID)") {
                        Image(uiImage: qrImage)
                            .interpolation(.none)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
                    }

                    Text("Código de Reserva: \(reservaID)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }

                // Detalles de la reserva
                VStack(spacing: 12) {
                    detalleRow(icono: "bus.fill", texto: camion.nombre)
                    detalleRow(icono: "clock.fill", texto: "Salida: \(camion.horaSalida)")
                    detalleRow(icono: "mappin.circle.fill", texto: camion.ruta.origen)
                    detalleRow(icono: "person.2.fill", texto: "\(numeroReservaciones) asiento\(numeroReservaciones > 1 ? "s" : "")")
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                .padding(.horizontal, 30)

                Spacer()

                // Botón Listo
                Button(action: {
                    onDismiss()
                }) {
                    Text("Listo")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
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
                        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                .accessibilityLabel("Listo")
                .accessibilityHint("Cierra la pantalla de confirmación")
            }
        }
        .transition(.scale.combined(with: .opacity))
    }

    private func detalleRow(icono: String, texto: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .font(.system(size: 18))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                .frame(width: 28)

            Text(texto)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Spacer()
        }
    }

    private func generarQRCode(texto: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(texto.utf8)
        filter.correctionLevel = "M"

        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)

            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return nil
    }
}

// MARK: - Preview

#Preview {
    ReservaCamionFlowView(camion: CamionMundial.sampleCamiones[0])
}
