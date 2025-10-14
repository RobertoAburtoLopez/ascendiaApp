//
//  BusModels.swift
//  ascendiaApp
//
//  Created by Claude Code on 14/10/25.
//

import Foundation
import CoreLocation

// MARK: - Estado del Camión

enum EstadoCamion: String, CaseIterable {
    case disponible = "Disponible"
    case proximo = "Próximo"
    case casiLleno = "Casi lleno"
    case agotado = "Agotado"

    var color: (red: Double, green: Double, blue: Double) {
        switch self {
        case .disponible:
            return (0.2, 0.8, 0.4)  // Verde
        case .proximo:
            return (0.2, 0.5, 0.9)  // Azul
        case .casiLleno:
            return (0.95, 0.75, 0.2) // Amarillo
        case .agotado:
            return (0.95, 0.3, 0.3)  // Rojo
        }
    }
}

// MARK: - Evento del Mundial

struct EventoMundial: Identifiable, Hashable {
    let id = UUID()
    let nombrePartido: String      // ej. "México vs. Argentina"
    let estadio: String             // ej. "Estadio Azteca"
    let ciudad: String              // ej. "Ciudad de México"
    let fecha: Date
    let horaInicio: String          // ej. "18:00"
    let coordenadas: CLLocationCoordinate2D
    let imagenEquipo1: String       // ej. nombre de SF Symbol
    let imagenEquipo2: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: EventoMundial, rhs: EventoMundial) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Punto de Abordaje

struct PuntoAbordaje: Identifiable, Hashable {
    let id = UUID()
    let nombre: String
    let direccion: String
    let hora: String
    let coordenadas: CLLocationCoordinate2D

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PuntoAbordaje, rhs: PuntoAbordaje) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Ruta del Camión

struct RutaCamion: Identifiable, Hashable {
    let id = UUID()
    let origen: String
    let paradas: [PuntoAbordaje]
    let destino: EventoMundial
    let polylineCoordinates: [CLLocationCoordinate2D]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: RutaCamion, rhs: RutaCamion) -> Bool {
        lhs.id == rhs.id
    }

    var descripcionRuta: String {
        let paradasTexto = paradas.map { $0.nombre }.joined(separator: " → ")
        return "\(origen) → \(paradasTexto) → \(destino.estadio)"
    }
}

// MARK: - Camión (Servicio de Transporte)

struct CamionMundial: Identifiable, Hashable {
    let id = UUID()
    let nombre: String              // ej. "Camión Seguro A"
    let ruta: RutaCamion
    let horaSalida: String          // ej. "14:00"
    let duracionEstimada: String    // ej. "2h 30min"
    let asientosDisponibles: Int
    let asientosTotales: Int
    let estado: EstadoCamion
    let costo: Double               // Precio en pesos
    let politicas: [String]         // Políticas del servicio

    var porcentajeOcupacion: Double {
        let ocupados = Double(asientosTotales - asientosDisponibles)
        return (ocupados / Double(asientosTotales)) * 100
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CamionMundial, rhs: CamionMundial) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Reserva

struct ReservaCamion: Identifiable {
    let id = UUID()
    let camion: CamionMundial
    let numeroAsiento: Int?
    let puntoAbordaje: PuntoAbordaje
    let fechaReserva: Date
    let confirmada: Bool
}

// MARK: - Filtros de Búsqueda

struct FiltrosCamion {
    var fechaSeleccionada: Date?
    var sedeSeleccionada: String?
    var estadosSeleccionados: Set<EstadoCamion> = Set(EstadoCamion.allCases)
    var duracionMaxima: Double? // en minutos

    func aplicar(a camiones: [CamionMundial]) -> [CamionMundial] {
        var resultado = camiones

        // Filtrar por fecha
        if let fecha = fechaSeleccionada {
            let calendar = Calendar.current
            resultado = resultado.filter { camion in
                calendar.isDate(camion.ruta.destino.fecha, inSameDayAs: fecha)
            }
        }

        // Filtrar por sede/ciudad
        if let sede = sedeSeleccionada, !sede.isEmpty {
            resultado = resultado.filter { camion in
                camion.ruta.destino.ciudad.lowercased().contains(sede.lowercased()) ||
                camion.ruta.destino.estadio.lowercased().contains(sede.lowercased())
            }
        }

        // Filtrar por estado
        resultado = resultado.filter { camion in
            estadosSeleccionados.contains(camion.estado)
        }

        // Filtrar por duración
        if let maxDuracion = duracionMaxima {
            resultado = resultado.filter { camion in
                let duracionMinutos = parsearDuracion(camion.duracionEstimada)
                return duracionMinutos <= maxDuracion
            }
        }

        return resultado
    }

    private func parsearDuracion(_ duracion: String) -> Double {
        // Parsea strings como "2h 30min" a minutos totales
        var totalMinutos: Double = 0

        if let horasRange = duracion.range(of: #"(\d+)h"#, options: .regularExpression) {
            let horasStr = duracion[horasRange].dropLast()
            totalMinutos += Double(horasStr) ?? 0 * 60
        }

        if let minutosRange = duracion.range(of: #"(\d+)min"#, options: .regularExpression) {
            let minutosStr = duracion[minutosRange].dropLast(3)
            totalMinutos += Double(minutosStr) ?? 0
        }

        return totalMinutos
    }
}

// MARK: - Datos de Ejemplo

extension EventoMundial {
    static let sampleEventos: [EventoMundial] = [
        EventoMundial(
            nombrePartido: "México vs. Argentina",
            estadio: "Estadio Azteca",
            ciudad: "Ciudad de México",
            fecha: Date().addingTimeInterval(86400 * 2), // En 2 días
            horaInicio: "18:00",
            coordenadas: CLLocationCoordinate2D(latitude: 19.3029, longitude: -99.1506),
            imagenEquipo1: "flag.fill",
            imagenEquipo2: "flag.fill"
        ),
        EventoMundial(
            nombrePartido: "Brasil vs. Uruguay",
            estadio: "Estadio BBVA",
            ciudad: "Monterrey",
            fecha: Date().addingTimeInterval(86400 * 3), // En 3 días
            horaInicio: "20:00",
            coordenadas: CLLocationCoordinate2D(latitude: 25.7204, longitude: -100.3097),
            imagenEquipo1: "flag.fill",
            imagenEquipo2: "flag.fill"
        ),
        EventoMundial(
            nombrePartido: "España vs. Alemania",
            estadio: "Estadio Akron",
            ciudad: "Guadalajara",
            fecha: Date().addingTimeInterval(86400 * 4), // En 4 días
            horaInicio: "19:30",
            coordenadas: CLLocationCoordinate2D(latitude: 20.6926, longitude: -103.4144),
            imagenEquipo1: "flag.fill",
            imagenEquipo2: "flag.fill"
        )
    ]
}

extension CamionMundial {
    static let sampleCamiones: [CamionMundial] = [
        CamionMundial(
            nombre: "Camión Seguro A",
            ruta: RutaCamion(
                origen: "Terminal Central",
                paradas: [
                    PuntoAbordaje(
                        nombre: "Centro Histórico",
                        direccion: "Av. Juárez 100",
                        hora: "14:30",
                        coordenadas: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332)
                    ),
                    PuntoAbordaje(
                        nombre: "Polanco",
                        direccion: "Av. Presidente Masaryk 200",
                        hora: "15:00",
                        coordenadas: CLLocationCoordinate2D(latitude: 19.4338, longitude: -99.1950)
                    )
                ],
                destino: EventoMundial.sampleEventos[0],
                polylineCoordinates: [
                    CLLocationCoordinate2D(latitude: 19.4270, longitude: -99.1676),
                    CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
                    CLLocationCoordinate2D(latitude: 19.4338, longitude: -99.1950),
                    CLLocationCoordinate2D(latitude: 19.3029, longitude: -99.1506)
                ]
            ),
            horaSalida: "14:00",
            duracionEstimada: "2h 30min",
            asientosDisponibles: 28,
            asientosTotales: 40,
            estado: .disponible,
            costo: 250.0,
            politicas: [
                "Solo mujeres y personas no binarias",
                "Prohibido fumar y consumir alcohol",
                "Se requiere identificación oficial",
                "El boleto es personal e intransferible"
            ]
        ),
        CamionMundial(
            nombre: "Camión Seguro B",
            ruta: RutaCamion(
                origen: "Terminal Norte",
                paradas: [
                    PuntoAbordaje(
                        nombre: "Satélite",
                        direccion: "Circuito Centro Comercial 50",
                        hora: "15:00",
                        coordenadas: CLLocationCoordinate2D(latitude: 19.5081, longitude: -99.2336)
                    )
                ],
                destino: EventoMundial.sampleEventos[0],
                polylineCoordinates: [
                    CLLocationCoordinate2D(latitude: 19.5126, longitude: -99.1313),
                    CLLocationCoordinate2D(latitude: 19.5081, longitude: -99.2336),
                    CLLocationCoordinate2D(latitude: 19.3029, longitude: -99.1506)
                ]
            ),
            horaSalida: "14:30",
            duracionEstimada: "2h 15min",
            asientosDisponibles: 8,
            asientosTotales: 40,
            estado: .casiLleno,
            costo: 230.0,
            politicas: [
                "Solo mujeres y personas no binarias",
                "Prohibido fumar y consumir alcohol",
                "Se requiere identificación oficial",
                "El boleto es personal e intransferible"
            ]
        ),
        CamionMundial(
            nombre: "Camión Seguro C",
            ruta: RutaCamion(
                origen: "Aeropuerto",
                paradas: [],
                destino: EventoMundial.sampleEventos[1],
                polylineCoordinates: [
                    CLLocationCoordinate2D(latitude: 19.4363, longitude: -99.0721),
                    CLLocationCoordinate2D(latitude: 25.7204, longitude: -100.3097)
                ]
            ),
            horaSalida: "08:00",
            duracionEstimada: "8h 00min",
            asientosDisponibles: 35,
            asientosTotales: 45,
            estado: .disponible,
            costo: 850.0,
            politicas: [
                "Solo mujeres y personas no binarias",
                "Incluye snacks y bebidas",
                "Paradas cada 2 horas",
                "WiFi a bordo disponible"
            ]
        ),
        CamionMundial(
            nombre: "Camión Seguro D",
            ruta: RutaCamion(
                origen: "Centro de Convenciones",
                paradas: [
                    PuntoAbordaje(
                        nombre: "Plaza Mayor",
                        direccion: "Av. Universidad 1000",
                        hora: "16:30",
                        coordenadas: CLLocationCoordinate2D(latitude: 20.6765, longitude: -103.3471)
                    )
                ],
                destino: EventoMundial.sampleEventos[2],
                polylineCoordinates: [
                    CLLocationCoordinate2D(latitude: 20.6597, longitude: -103.3496),
                    CLLocationCoordinate2D(latitude: 20.6765, longitude: -103.3471),
                    CLLocationCoordinate2D(latitude: 20.6926, longitude: -103.4144)
                ]
            ),
            horaSalida: "16:00",
            duracionEstimada: "1h 15min",
            asientosDisponibles: 18,
            asientosTotales: 40,
            estado: .proximo,
            costo: 180.0,
            politicas: [
                "Solo mujeres y personas no binarias",
                "Salida confirmada con mínimo 20 personas",
                "Reembolso completo 24h antes del evento"
            ]
        ),
        CamionMundial(
            nombre: "Camión Seguro E",
            ruta: RutaCamion(
                origen: "Zona Rosa",
                paradas: [],
                destino: EventoMundial.sampleEventos[0],
                polylineCoordinates: [
                    CLLocationCoordinate2D(latitude: 19.4284, longitude: -99.1677),
                    CLLocationCoordinate2D(latitude: 19.3029, longitude: -99.1506)
                ]
            ),
            horaSalida: "16:00",
            duracionEstimada: "1h 45min",
            asientosDisponibles: 0,
            asientosTotales: 35,
            estado: .agotado,
            costo: 200.0,
            politicas: [
                "Solo mujeres y personas no binarias",
                "Servicio directo sin paradas",
                "Lista de espera disponible"
            ]
        )
    ]
}
