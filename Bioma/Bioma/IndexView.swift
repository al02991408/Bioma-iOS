//
//  IndexView.swift
//  bioma
//
//  Created by Alumno on 27/03/25.
//

import SwiftUI
import MapKit
import CoreLocation

// 📌 Modelo de Reporte
struct Report: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let icon: String
    let color: Color
    var isSelected: Bool = false
}

// 📍 Manejo de Ubicación del Usuario
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener ubicación: \(error.localizedDescription)")
    }
}

// 🌍 Vista principal
struct IndexView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var reportManager = ReportManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var reports: [Report] = [
        Report(title: "Incendio", coordinate: CLLocationCoordinate2D(latitude: 25.7000, longitude: -100.3300), icon: "flame.fill", color: Color.red.opacity(1.0)),
        Report(title: "Árbol Caído", coordinate: CLLocationCoordinate2D(latitude: 25.6800, longitude: -100.3450), icon: "leaf.fill", color: Color.green.opacity(1.0)),
        Report(title: "Inundación", coordinate: CLLocationCoordinate2D(latitude: 25.7100, longitude: -100.2950), icon: "water.waves", color: Color.blue.opacity(1.0)),
        Report(title: "Animal Suelto", coordinate: CLLocationCoordinate2D(latitude: 25.6750, longitude: -100.3200), icon: "pawprint.fill", color: Color.brown.opacity(1.0)),
        Report(title: "Otros", coordinate: CLLocationCoordinate2D(latitude: 25.7250, longitude: -100.3100), icon: "exclamationmark.triangle.fill", color: Color.yellow.opacity(1.0))
    ]
    
    
    @State private var showMenu = false
    @State private var airQuality = "Buena" // Simulación
    @State private var hasUpdatedLocation = false // ✅ Se usa para actualizar solo una vez la ubicación
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 🌍 Mapa con anotaciones
                Map(coordinateRegion: $region, annotationItems: reports) { report in
                    MapAnnotation(coordinate: report.coordinate) {
                        ZStack {
                            // Imagen del reporte
                            Image(systemName: report.icon)
                                .foregroundColor(report.color)
                                .font(.title)
                                .padding(5)
                                .background(Color.white.opacity(0.7))
                                .clipShape(Circle())
                                .onTapGesture {
                                    if let index = reports.firstIndex(where: { $0.id == report.id }) {
                                        reports[index].isSelected.toggle()
                                    }
                                }
                            
                            if report.isSelected {
                                NavigationLink(
                                    destination: ReportDetailView(report: report),
                                    label: {
                                        Circle()
                                            .fill(Color.black.opacity(0.5))
                                            .frame(width: 40, height: 40)
                                    })
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .onReceive(locationManager.$userLocation) { location in
                    if let newLocation = location, !hasUpdatedLocation {
                        region = MKCoordinateRegion(
                            center: newLocation,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                        hasUpdatedLocation = true
                    }
                }
                
                
                VStack {
                    // 🏠 Barra superior
                    HStack {
                        VStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.biomaDarkGreen)
                                .padding(0.5)
                            
                            Text("danyesc") // Aquí va el nombre de usuario
                                .font(.system(size: 12)) // Tamaño pequeño
                                .foregroundColor(.black) // Color negro
                                .bold()
                            
                        }
                        .padding(.bottom, 10)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            HStack(spacing: 10) { // Ajusta el espaciado aquí
                                Image("BiomaInicio2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text("Bioma")
                                    .font(.custom("Georgia", size: 30))
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 5)
                            
                            
                            HStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 10, height: 10) // Ajusta el tamaño según lo necesites
                                
                                Text("Calidad del aire: \(airQuality)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                    .background(Color.biomaBeige.opacity(0.8))
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // 📍 Botón para centrar en la ubicación actual (aquí movido a la esquina superior derecha)
                    HStack {
                        Button(action: {
                            if let newLocation = locationManager.userLocation {
                                region = MKCoordinateRegion(
                                    center: newLocation,
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                )
                            }
                        }) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 60, height: 60)
                                .background(Color.biomaDarkGreen)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.top, 10)
                    }
                    //Botón para crear reporte
                        NavigationLink(destination: ReportesView()) {
                            Text("Crear Reporte")
                                .font(.title3)
                                .bold()
                                .padding()
                                .frame(width: 180)
                                .background(Color.biomaLightGreen)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.bottom, 20)
                        
                        // 📜 Menú
                        VStack {
                            Button(action: { showMenu.toggle() }) {
                                Image(systemName: "line.horizontal.3")
                                    .foregroundColor(Color.biomaDarkGreen)
                                    .padding()
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            
                            if showMenu {
                                VStack(spacing: 15) {
                                    MenuButton(title: "Ver Clima y Recomendaciones", destination: ClimaView())
                                    MenuButton(title: "Eventos Ecológicos", destination: EventsView())
                                    MenuButton(title: "Conviértete en un Eco-Guardián", destination: CommunityView())
                                }
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                            }
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
    
    // 📌 Botón del menú
    struct MenuButton<Destination: View>: View {
        let title: String
        let destination: Destination
        
        var body: some View {
            NavigationLink(destination: destination) {
                Text(title)
                    .foregroundColor(Color.biomaDarkGreen)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.biomaBeige)
                    .cornerRadius(8)
            }
        }
    }
    
    // 👀 Vista previa
    #Preview {
        IndexView()
    }


