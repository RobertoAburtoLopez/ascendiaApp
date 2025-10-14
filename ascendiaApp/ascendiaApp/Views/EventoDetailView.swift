//
//  EventoDetailView.swift
//  ascendiaApp
//
//  Created by Claude Code on 14/10/25.
//

import SwiftUI
import MapKit

struct EventoDetailView: View {
    let evento: EventoMundial
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // HEADER: Banner del partido
                headerBanner

                // INFO DEL PARTIDO
                partidoInfoSection

                Divider()
                    .padding(.horizontal, 20)

                // ESTADIO
                estadioSection

                Divider()
                    .padding(.horizontal, 20)

                // MAPA DEL ESTADIO
                mapaSection

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
        .navigationTitle("Detalles del Evento")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header Banner

    private var headerBanner: some View {
        VStack(spacing: 16) {
            // Ícono de fútbol
            ZStack {
                Circle()
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
                    .frame(width: 100, height: 100)

                Image(systemName: "soccerball")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            .shadow(color: Color.purple.opacity(0.3), radius: 12, x: 0, y: 6)

            // Nombre del partido
            Text(evento.nombrePartido)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .multilineTextAlignment(.center)

            // Badge de Mundial
            Text("Copa Mundial FIFA")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(red: 0.9, green: 0.2, blue: 0.6))
                .cornerRadius(20)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 20)
    }

    // MARK: - Partido Info Section

    private var partidoInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información del Partido")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            VStack(spacing: 14) {
                infoRow(
                    icon: "calendar",
                    titulo: "Fecha",
                    valor: formatearFecha(evento.fecha)
                )

                infoRow(
                    icon: "clock.fill",
                    titulo: "Hora de Inicio",
                    valor: evento.horaInicio
                )

                infoRow(
                    icon: "sportscourt.fill",
                    titulo: "Tipo",
                    valor: "Partido de Fase de Grupos"
                )
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 3)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Estadio Section

    private var estadioSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estadio")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            VStack(spacing: 14) {
                infoRow(
                    icon: "building.2.fill",
                    titulo: "Nombre",
                    valor: evento.estadio
                )

                infoRow(
                    icon: "mappin.circle.fill",
                    titulo: "Ubicación",
                    valor: evento.ciudad
                )

                infoRow(
                    icon: "location.fill",
                    titulo: "Coordenadas",
                    valor: String(format: "%.4f°, %.4f°", evento.coordenadas.latitude, evento.coordenadas.longitude)
                )
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 3)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Mapa Section

    private var mapaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ubicación del Estadio")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .padding(.horizontal, 20)

            // Mapa estático con pin
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.92, green: 0.94, blue: 0.96))
                    .frame(height: 250)

                VStack(spacing: 12) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.3))

                    Text("Mapa del Estadio")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.5))

                    Text(evento.estadio)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                }

                // Pin del estadio
                VStack {
                    Spacer()
                        .frame(height: 100)

                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.9, green: 0.2, blue: 0.6))
                        .shadow(color: Color.purple.opacity(0.4), radius: 8, x: 0, y: 4)

                    Spacer()
                }
            }
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
            .padding(.horizontal, 20)

            // Botón para abrir en Mapas
            Button(action: {
                abrirEnMapas()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "map")
                        .font(.system(size: 16))

                    Text("Abrir en Mapas")
                        .font(.system(size: 16, weight: .semibold))
                }
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
            .padding(.horizontal, 20)
            .accessibilityLabel("Abrir ubicación del estadio en Mapas")
        }
    }

    // MARK: - Helper Views

    private func infoRow(icon: String, titulo: String, valor: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {
                Text(titulo)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                Text(valor)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }

            Spacer()
        }
    }

    // MARK: - Helper Functions

    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM 'de' yyyy"
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: fecha)
    }

    private func abrirEnMapas() {
        let coordinate = evento.coordenadas
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = evento.estadio
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])

        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        #endif
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EventoDetailView(evento: EventoMundial.sampleEventos[0])
    }
}
