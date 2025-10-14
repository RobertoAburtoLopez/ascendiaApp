//
//  FiltrosCamionesSheet.swift
//  ascendiaApp
//
//  Created by Claude Code on 14/10/25.
//

import SwiftUI

struct FiltrosCamionesSheet: View {
    @Binding var filtros: FiltrosCamion
    @Environment(\.dismiss) var dismiss

    @State private var fechaTemporal: Date = Date()
    @State private var usarFiltroFecha = false
    @State private var sedeTemporal = ""
    @State private var estadosTemporales: Set<EstadoCamion> = Set(EstadoCamion.allCases)
    @State private var duracionMaximaTemporal: Double = 600 // 10 horas en minutos
    @State private var usarFiltroDuracion = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // FECHA
                    fechaSection

                    Divider()
                        .padding(.horizontal, 20)

                    // SEDE/CIUDAD
                    sedeSection

                    Divider()
                        .padding(.horizontal, 20)

                    // ESTADO
                    estadoSection

                    Divider()
                        .padding(.horizontal, 20)

                    // DURACIÓN
                    duracionSection

                    Spacer()
                        .frame(height: 20)
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
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Limpiar") {
                        limpiarFiltros()
                    }
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Aplicar") {
                        aplicarFiltros()
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                }
            }
            .onAppear {
                cargarFiltrosActuales()
            }
        }
    }

    // MARK: - Fecha Section

    private var fechaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Fecha del Evento")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                Spacer()

                Toggle("", isOn: $usarFiltroFecha)
                    .labelsHidden()
                    .tint(Color(red: 0.6, green: 0.4, blue: 0.8))
            }
            .padding(.horizontal, 20)

            if usarFiltroFecha {
                VStack(spacing: 12) {
                    DatePicker(
                        "",
                        selection: $fechaTemporal,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .accentColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                    Text("Eventos programados para: \(formatearFecha(fechaTemporal))")
                        .font(.system(size: 13))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut, value: usarFiltroFecha)
    }

    // MARK: - Sede Section

    private var sedeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Sede / Ciudad")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                TextField("Buscar por estadio o ciudad", text: $sedeTemporal)
                    .textFieldStyle(.plain)
                    .padding(14)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.98))
                    .cornerRadius(12)

                // Opciones rápidas
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sugerencias:")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["Ciudad de México", "Monterrey", "Guadalajara", "Puebla"], id: \.self) { ciudad in
                                Button(action: {
                                    sedeTemporal = ciudad
                                }) {
                                    Text(ciudad)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(
                                            sedeTemporal == ciudad ?
                                                .white :
                                                Color(red: 0.6, green: 0.4, blue: 0.8)
                                        )
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            sedeTemporal == ciudad ?
                                                Color(red: 0.6, green: 0.4, blue: 0.8) :
                                                Color.white
                                        )
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.8), lineWidth: 1.5)
                                        )
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Estado Section

    private var estadoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Estado de Disponibilidad")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                ForEach(EstadoCamion.allCases, id: \.self) { estado in
                    estadoToggle(estado: estado)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Duración Section

    private var duracionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "timer")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                Text("Duración Máxima")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                Spacer()

                Toggle("", isOn: $usarFiltroDuracion)
                    .labelsHidden()
                    .tint(Color(red: 0.6, green: 0.4, blue: 0.8))
            }
            .padding(.horizontal, 20)

            if usarFiltroDuracion {
                VStack(spacing: 16) {
                    HStack {
                        Text("Hasta:")
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                        Spacer()

                        Text(formatearDuracion(duracionMaximaTemporal))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                    }

                    Slider(
                        value: $duracionMaximaTemporal,
                        in: 30...600,
                        step: 15
                    )
                    .tint(Color(red: 0.6, green: 0.4, blue: 0.8))

                    HStack {
                        Text("30 min")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)

                        Spacer()

                        Text("10 hrs")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut, value: usarFiltroDuracion)
    }

    // MARK: - Helper Views

    private func estadoToggle(estado: EstadoCamion) -> some View {
        let color = estado.color
        let isSelected = estadosTemporales.contains(estado)

        return Button(action: {
            if isSelected {
                estadosTemporales.remove(estado)
            } else {
                estadosTemporales.insert(estado)
            }

            #if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            #endif
        }) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.8) : Color.gray)

                Text(estado.rawValue)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                Spacer()

                // Badge de color
                Circle()
                    .fill(Color(red: color.red, green: color.green, blue: color.blue))
                    .frame(width: 12, height: 12)
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Helper Functions

    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: fecha)
    }

    private func formatearDuracion(_ minutos: Double) -> String {
        let horas = Int(minutos) / 60
        let mins = Int(minutos) % 60

        if horas == 0 {
            return "\(mins) min"
        } else if mins == 0 {
            return "\(horas) hrs"
        } else {
            return "\(horas)h \(mins)min"
        }
    }

    private func cargarFiltrosActuales() {
        if let fecha = filtros.fechaSeleccionada {
            fechaTemporal = fecha
            usarFiltroFecha = true
        }

        if let sede = filtros.sedeSeleccionada {
            sedeTemporal = sede
        }

        estadosTemporales = filtros.estadosSeleccionados

        if let duracion = filtros.duracionMaxima {
            duracionMaximaTemporal = duracion
            usarFiltroDuracion = true
        }
    }

    private func aplicarFiltros() {
        filtros.fechaSeleccionada = usarFiltroFecha ? fechaTemporal : nil
        filtros.sedeSeleccionada = sedeTemporal.isEmpty ? nil : sedeTemporal
        filtros.estadosSeleccionados = estadosTemporales
        filtros.duracionMaxima = usarFiltroDuracion ? duracionMaximaTemporal : nil

        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        #endif
    }

    private func limpiarFiltros() {
        usarFiltroFecha = false
        fechaTemporal = Date()
        sedeTemporal = ""
        estadosTemporales = Set(EstadoCamion.allCases)
        usarFiltroDuracion = false
        duracionMaximaTemporal = 600

        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        #endif
    }
}

// MARK: - Preview

#Preview {
    FiltrosCamionesSheet(filtros: .constant(FiltrosCamion()))
}
