//
//  BusTripCardView.swift
//  ascendiaApp
//
//  Created by Claude Code on 14/10/25.
//

import SwiftUI

struct BusTripCardView: View {
    let camion: CamionMundial
    let onReservar: () -> Void
    let onVerEnMapa: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // HEADER: Ícono de autobús + Nombre del servicio
            HStack(spacing: 12) {
                // Ícono de autobús con fondo degradado
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
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
                        .frame(width: 56, height: 56)

                    Image(systemName: "bus.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(camion.nombre)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                    Text(camion.ruta.destino.nombrePartido)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                }

                Spacer()

                // Badge de estado
                estadoBadge
            }

            // RUTA
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

                    Text("Ruta")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }

                Text(rutaDescripcion)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .lineSpacing(4)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(red: 0.96, green: 0.96, blue: 0.98))
            .cornerRadius(12)

            // METADATOS: Hora, Duración, Asientos
            HStack(spacing: 16) {
                // Hora de salida
                metadatoItem(
                    icon: "clock.fill",
                    texto: camion.horaSalida,
                    label: "Salida"
                )

                Divider()
                    .frame(height: 30)

                // Duración
                metadatoItem(
                    icon: "timer",
                    texto: camion.duracionEstimada,
                    label: "Duración"
                )

                Divider()
                    .frame(height: 30)

                // Asientos disponibles
                metadatoItem(
                    icon: "person.2.fill",
                    texto: "\(camion.asientosDisponibles)",
                    label: "Disponibles"
                )
            }
            .padding(.vertical, 4)

            // DESTINO: Estadio y ciudad
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.9, green: 0.2, blue: 0.6))

                VStack(alignment: .leading, spacing: 2) {
                    Text(camion.ruta.destino.estadio)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                    Text(camion.ruta.destino.ciudad)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                }

                Spacer()

                // Precio
                Text("$\(Int(camion.costo))")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            }
            .padding(.top, 4)

            // BOTONES
            HStack(spacing: 12) {
                // Botón Ver en mapa (outline)
                Button(action: onVerEnMapa) {
                    HStack(spacing: 6) {
                        Image(systemName: "map")
                            .font(.system(size: 14, weight: .semibold))

                        Text("Ver en mapa")
                            .font(.system(size: 15, weight: .semibold))
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
                .accessibilityLabel("Ver \(camion.nombre) en el mapa")
                .accessibilityHint("Muestra la ruta del camión en el mapa")

                // Botón Reservar (degradado)
                Button(action: onReservar) {
                    Text(camion.estado == .agotado ? "Agotado" : "Reservar")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            camion.estado == .agotado ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray, Color.gray]),
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
                        .cornerRadius(14)
                        .shadow(
                            color: camion.estado == .agotado ? Color.clear : Color.purple.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .disabled(camion.estado == .agotado)
                .accessibilityLabel(camion.estado == .agotado ? "Camión agotado" : "Reservar asiento en \(camion.nombre)")
                .accessibilityHint(camion.estado == .agotado ? "No hay asientos disponibles" : "Abre el formulario de reserva")
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tarjeta de \(camion.nombre)")
    }

    // MARK: - Vista de Badge de Estado

    private var estadoBadge: some View {
        let color = camion.estado.color
        return Text(camion.estado.rawValue)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(Color(red: color.red, green: color.green, blue: color.blue))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Color(red: color.red, green: color.green, blue: color.blue).opacity(0.15)
            )
            .cornerRadius(8)
    }

    // MARK: - Descripción de la Ruta

    private var rutaDescripcion: String {
        let paradas = camion.ruta.paradas.isEmpty ? "Sin paradas" : camion.ruta.paradas.map { $0.nombre }.joined(separator: " → ")
        let rutaCompleta = camion.ruta.paradas.isEmpty ?
            "\(camion.ruta.origen) → \(camion.ruta.destino.estadio)" :
            "\(camion.ruta.origen) → \(paradas) → \(camion.ruta.destino.estadio)"
        return rutaCompleta
    }

    // MARK: - Item de Metadato

    private func metadatoItem(icon: String, texto: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))

            Text(texto)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(CamionMundial.sampleCamiones.prefix(3)) { camion in
                BusTripCardView(
                    camion: camion,
                    onReservar: {
                        print("Reservar \(camion.nombre)")
                    },
                    onVerEnMapa: {
                        print("Ver en mapa \(camion.nombre)")
                    }
                )
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 20)
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
    }
}
