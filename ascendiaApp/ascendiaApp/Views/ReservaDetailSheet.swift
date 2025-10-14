//
//  ReservaDetailSheet.swift
//  ascendiaApp
//
//  Created by Claude Code on 14/10/25.
//

import SwiftUI

struct ReservaDetailSheet: View {
    let camion: CamionMundial
    @Environment(\.dismiss) var dismiss
    @State private var asientoSeleccionado: Int? = nil
    @State private var puntoAbordajeSeleccionado: PuntoAbordaje? = nil
    @State private var mostrarConfirmacion = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // HEADER: Info del camión
                    headerSection

                    Divider()
                        .padding(.horizontal, 20)

                    // DETALLES DEL EVENTO
                    eventoSection

                    Divider()
                        .padding(.horizontal, 20)

                    // PUNTOS DE ABORDAJE
                    puntosAbordajeSection

                    Divider()
                        .padding(.horizontal, 20)

                    // SELECTOR DE ASIENTO (Placeholder)
                    selectorAsientoSection

                    Divider()
                        .padding(.horizontal, 20)

                    // POLÍTICAS
                    politicasSection

                    Divider()
                        .padding(.horizontal, 20)

                    // COSTO
                    costoSection

                    // BOTÓN CONFIRMAR
                    confirmarButton
                        .padding(.top, 10)
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
            .navigationTitle("Detalles de Reserva")
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
            .alert("Reserva Confirmada", isPresented: $mostrarConfirmacion) {
                Button("Aceptar", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Tu reserva ha sido confirmada. Recibirás un correo con los detalles.")
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        HStack(spacing: 16) {
            // Ícono
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.6, green: 0.4, blue: 0.8),
                                Color(red: 0.9, green: 0.2, blue: 0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)

                Image(systemName: "bus.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(camion.nombre)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                Text("Salida: \(camion.horaSalida)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                Text("Duración: \(camion.duracionEstimada)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Evento Section

    private var eventoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Evento del Mundial")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            VStack(alignment: .leading, spacing: 8) {
                infoRow(icon: "sportscourt.fill", texto: camion.ruta.destino.nombrePartido)
                infoRow(icon: "building.2.fill", texto: camion.ruta.destino.estadio)
                infoRow(icon: "mappin.circle.fill", texto: camion.ruta.destino.ciudad)
                infoRow(icon: "clock.fill", texto: "Inicio: \(camion.ruta.destino.horaInicio)")
                infoRow(icon: "calendar", texto: formatearFecha(camion.ruta.destino.fecha))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Puntos de Abordaje Section

    private var puntosAbordajeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Selecciona tu punto de abordaje")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            if camion.ruta.paradas.isEmpty {
                // Punto único (origen)
                puntoAbordajeCard(
                    nombre: camion.ruta.origen,
                    direccion: "Punto de salida",
                    hora: camion.horaSalida,
                    isSelected: puntoAbordajeSeleccionado?.nombre == camion.ruta.origen
                )
                .onTapGesture {
                    puntoAbordajeSeleccionado = PuntoAbordaje(
                        nombre: camion.ruta.origen,
                        direccion: "Punto de salida",
                        hora: camion.horaSalida,
                        coordenadas: camion.ruta.polylineCoordinates.first ?? .init(latitude: 0, longitude: 0)
                    )
                }
            } else {
                // Múltiples paradas
                ForEach(camion.ruta.paradas) { parada in
                    puntoAbordajeCard(
                        nombre: parada.nombre,
                        direccion: parada.direccion,
                        hora: parada.hora,
                        isSelected: puntoAbordajeSeleccionado?.id == parada.id
                    )
                    .onTapGesture {
                        puntoAbordajeSeleccionado = parada
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Selector de Asiento Section

    private var selectorAsientoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Selecciona tu asiento (Opcional)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            Text("Puedes seleccionar un asiento específico o dejar que se asigne automáticamente al abordar.")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                .lineSpacing(3)

            // Placeholder de selector de asiento
            VStack(spacing: 12) {
                Text("Asientos Disponibles: \(camion.asientosDisponibles)/\(camion.asientosTotales)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                // Grid de asientos (simplified placeholder)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                    ForEach(1...min(16, camion.asientosTotales), id: \.self) { numero in
                        asientoButton(numero: numero)
                    }
                }

                if camion.asientosTotales > 16 {
                    Text("...y \(camion.asientosTotales - 16) asientos más")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Políticas Section

    private var politicasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Políticas del Servicio")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            VStack(alignment: .leading, spacing: 10) {
                ForEach(camion.politicas, id: \.self) { politica in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                        Text(politica)
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                            .lineSpacing(3)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Costo Section

    private var costoSection: some View {
        HStack {
            Text("Costo Total:")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Spacer()

            Text("$\(Int(camion.costo)) MXN")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Confirmar Button

    private var confirmarButton: some View {
        Button(action: {
            // Validar que haya seleccionado punto de abordaje
            guard puntoAbordajeSeleccionado != nil else {
                return
            }

            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            #endif

            mostrarConfirmacion = true
        }) {
            Text("Confirmar Reserva")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    puntoAbordajeSeleccionado == nil ?
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
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
                .shadow(
                    color: puntoAbordajeSeleccionado == nil ? Color.clear : Color.purple.opacity(0.3),
                    radius: 10,
                    x: 0,
                    y: 5
                )
        }
        .disabled(puntoAbordajeSeleccionado == nil)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .accessibilityLabel("Confirmar reserva")
        .accessibilityHint(puntoAbordajeSeleccionado == nil ? "Selecciona un punto de abordaje primero" : "Confirma tu reserva de \(camion.nombre)")
    }

    // MARK: - Helper Views

    private func infoRow(icon: String, texto: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                .frame(width: 24)

            Text(texto)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Spacer()
        }
    }

    private func puntoAbordajeCard(nombre: String, direccion: String, hora: String, isSelected: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.8) : Color.gray)

            VStack(alignment: .leading, spacing: 4) {
                Text(nombre)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                Text(direccion)
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                Text("Hora: \(hora)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.4))
            }
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isSelected ? Color(red: 0.6, green: 0.4, blue: 0.8) : Color.clear,
                    lineWidth: 2
                )
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05), radius: 8, x: 0, y: 2)
        .accessibilityLabel("Punto de abordaje \(nombre), hora \(hora)")
        .accessibilityHint(isSelected ? "Seleccionado" : "Toca para seleccionar")
    }

    private func asientoButton(numero: Int) -> some View {
        let estaOcupado = numero > camion.asientosDisponibles
        let estaSeleccionado = asientoSeleccionado == numero

        return Button(action: {
            if !estaOcupado {
                asientoSeleccionado = estaSeleccionado ? nil : numero
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: estaOcupado ? "xmark" : (estaSeleccionado ? "checkmark" : "person.fill"))
                    .font(.system(size: 16))
                    .foregroundColor(
                        estaOcupado ? .gray :
                        estaSeleccionado ? .white :
                        Color(red: 0.6, green: 0.4, blue: 0.8)
                    )

                Text("\(numero)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(
                        estaOcupado ? .gray :
                        estaSeleccionado ? .white :
                        Color(red: 0.3, green: 0.3, blue: 0.3)
                    )
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if estaOcupado {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else if estaSeleccionado {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.6, green: 0.4, blue: 0.8),
                                Color(red: 0.9, green: 0.2, blue: 0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.white]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .disabled(estaOcupado)
        .accessibilityLabel("Asiento \(numero)")
        .accessibilityHint(estaOcupado ? "Ocupado" : (estaSeleccionado ? "Seleccionado, toca para deseleccionar" : "Disponible, toca para seleccionar"))
    }

    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: fecha)
    }
}

// MARK: - Preview

#Preview {
    ReservaDetailSheet(camion: CamionMundial.sampleCamiones[0])
}
