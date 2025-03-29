//
//  ClimaView.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 29/03/25.
//

import SwiftUI
import CoreLocation

// Vista principal para mostrar el clima
struct ClimaView: View {
    
    @State private var clima: Clima?
    @State private var errorMessage: String?
    @State private var loading = false
    @State private var locationManager = CLLocationManager()
    @State private var location: CLLocationCoordinate2D?
    @State private var locationName: String = "" // Nombre de la ubicación actual
    
    let apiKey = "bbf6d314b6d64e1681c42245252803" // Tu clave API
    
    var body: some View {
        ZStack {
            // Fondo con el color "Primario" desde tus assets
            Color("Primario")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if loading {
                    // Mostrar un indicador de carga
                    ProgressView("Cargando clima...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                } else if let clima = clima {
                    // Mostrar los detalles del clima
                    HStack {
                        Text("Clima Actual")
                            .font(.largeTitle)
                            .foregroundColor(Color("Cuarto"))
                            .padding()
                        
                        // Mostrar la imagen relacionada al clima
                        Image("BiomaInicio2") // Asegúrate de que esta imagen esté en tus assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    
                    // Icono relacionado al clima con el color adecuado
                    climaIcono(clima: clima)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding()
                    
                    // Mostrar la temperatura
                    Text("\(Image(systemName: "thermometer")) \(String(format: "%.1f", clima.temperatura))°C")
                        .font(.title)
                        .foregroundColor(Color("Primario"))
                        .padding()
                        .background(Color("Cuarto").opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    
                    // Mostrar la descripción del clima
                    Text("\(Image(systemName: "cloud.sun.fill")) \(clima.descripcion.capitalized)")
                        .font(.title2)
                        .foregroundColor(Color("Cuarto"))
                        .padding()
                    
                    // Mostrar la humedad
                    Text("\(Image(systemName: "drop.fill")) \(String(format: "%.0f", clima.humedad))%")
                        .font(.title3)
                        .foregroundColor(Color("Cuarto"))
                        .padding()
                    
                    // Mostrar la velocidad del viento
                    Text("\(Image(systemName: "wind")) \(String(format: "%.1f", clima.viento)) m/s")
                        .font(.title3)
                        .foregroundColor(Color("Cuarto"))
                        .padding()
                    
                    // Recomendaciones basadas en el clima actual
                    recomendaciones(clima: clima)
                } else if let errorMessage = errorMessage {
                    // Mostrar mensaje de error si no se puede obtener el clima
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                }
            }
            .onAppear {
                // Solicitar permisos de ubicación y obtener la ubicación
                locationManager.requestWhenInUseAuthorization()
                if let location = locationManager.location?.coordinate {
                    self.location = location
                    cargarClima() // Cargar el clima con la ubicación actual
                    obtenerNombreUbicacion() // Obtener el nombre de la ubicación
                }
            }
            .padding()
        }
    }
    
    // Función para cargar el clima desde la API
    func cargarClima() {
        guard let location = location else {
            errorMessage = "No se pudo obtener la ubicación"
            loading = false
            return
        }
        
        loading = true
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)"
        guard let url = URL(string: urlString) else {
            errorMessage = "URL inválida"
            loading = false
            return
        }
        
        // Realizar la solicitud de datos a la API
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.loading = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Datos no disponibles"
                    self.loading = false
                }
                return
            }
            
            // Decodificar los datos JSON obtenidos de la API
            do {
                let response = try JSONDecoder().decode(ClimaAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.clima = Clima(
                        temperatura: response.current.temp_c,
                        descripcion: response.current.condition.text,
                        humedad: response.current.humidity,
                        viento: response.current.wind_kph / 3.6 // Convertir km/h a m/s
                    )
                    self.loading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al procesar los datos"
                    self.loading = false
                }
            }
        }.resume()
    }
    
    // Función para obtener el nombre de la ubicación actual
    func obtenerNombreUbicacion() {
        guard let location = location else {
            errorMessage = "No se pudo obtener la ubicación"
            loading = false
            return
        }
        
        let geocoder = CLGeocoder()
        let locationInstance = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        // Obtener el nombre de la ubicación a partir de las coordenadas
        geocoder.reverseGeocodeLocation(locationInstance) { (placemarks, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.loading = false
                }
                return
            }
            
            guard let placemarks = placemarks, let placemark = placemarks.first else {
                DispatchQueue.main.async {
                    self.errorMessage = "No se pudo obtener la información de la ubicación"
                    self.loading = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self.locationName = placemark.locality ?? "Ubicación desconocida"
                self.loading = false
            }
        }
    }
    
    // Función para obtener el icono SF correspondiente al clima con colores personalizados
    func climaIcono(clima: Clima) -> some View {
        let iconName = climaIconoNombre(clima: clima)
        let iconColor = colorPorClima(clima: clima)
        
        return Image(systemName: iconName)
            .font(.system(size: 50))
            .foregroundColor(iconColor)
    }
    
    // Función que devuelve el nombre del icono SF según la descripción del clima
    func climaIconoNombre(clima: Clima) -> String {
        switch clima.descripcion.lowercased() {
        case let x where x.contains("rain"):
            return "cloud.rain.fill" // Lluvia
        case let x where x.contains("cloud"):
            return "cloud.fill" // Nubes
        case let x where x.contains("sunny") || x.contains("clear"):
            return "sun.max.fill" // Sol
        default:
            return "cloud.sun.fill" // Clima desconocido
        }
    }
    
    // Función para obtener el color del ícono basado en la descripción del clima
    func colorPorClima(clima: Clima) -> Color {
        switch clima.descripcion.lowercased() {
        case let x where x.contains("rain"):
            return Color.blue // Azul para lluvia
        case let x where x.contains("cloud"):
            return Color.gray // Gris para nubes
        case let x where x.contains("sunny") || x.contains("clear"):
            return Color.yellow // Amarillo para sol
        default:
            return Color.orange // Naranja para clima desconocido
        }
    }
    
    // Función para mostrar recomendaciones basadas en el clima
    func recomendaciones(clima: Clima) -> some View {
        VStack {
            if clima.descripcion.contains("rain") {
                Text("🌧️ Lleva paraguas, podría llover.")
                    .foregroundColor(Color("Cuarto"))
            } else if clima.descripcion.contains("cloud") {
                Text("☁️ El clima está nublado, lleva algo para abrigarte.")
                    .foregroundColor(Color("Cuarto"))
            } else if clima.descripcion.contains("sunny") {
                Text("☀️ ¡Un día soleado! No olvides tu protector solar.")
                    .foregroundColor(Color("Cuarto"))
            } else {
                Text("🌤️ Clima moderado, ideal para estar al aire libre.")
                    .foregroundColor(Color("Cuarto"))
            }
        }
        .font(.title2)
        .padding()
        .frame(maxWidth: .infinity, alignment: .center) // Centra el texto
    }
}

// Estructuras para manejar la respuesta de la API
struct ClimaAPIResponse: Codable {
    let current: ClimaActual
}

struct ClimaActual: Codable {
    let temp_c: Double
    let condition: Condicion
    let humidity: Double
    let wind_kph: Double
}

struct Condicion: Codable {
    let text: String
}

// Estructura para almacenar los datos del clima
struct Clima {
    let temperatura: Double
    let descripcion: String
    let humedad: Double
    let viento: Double
}
