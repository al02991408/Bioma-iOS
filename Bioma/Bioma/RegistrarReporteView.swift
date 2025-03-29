
//
//  RegistrarReporteView.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 28/03/25.
//

import SwiftUI
import MapKit

struct RegistrarReporteView: View {
    let reporte: String
    @ObservedObject var reportManager: ReportManager
    
    // Variables de estado
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var consejo: String = ""
    @State private var magnitud: Double = 5
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    @State private var climaLocation: CLLocationCoordinate2D? = nil
    
    // Diccionario de íconos para cada tipo de reporte
    let reporteIcons: [String: String] = [
        "Incendio": "flame.fill",
        "Árbol Caído": "leaf.fill",
        "Inundación": "water.waves.fill",
        "Animal Suelto": "pawprint.fill"
    ]
    
    // Diccionario de colores para cada tipo de reporte
    let reporteColors: [String: Color] = [
        "Incendio": .red,
        "Árbol Caído": .green,
        "Inundación": .blue,
        "Animal Suelto": .brown
    ]
    
    // Determinamos el ícono correspondiente
    var reporteIcon: String {
        return reporteIcons[reporte] ?? "questionmark.circle.fill"  // Si no hay ícono, usamos un valor predeterminado
    }
    
    var reporteColor: Color {
        return reporteColors[reporte] ?? .gray // Si no hay un color definido, usa gris por defecto
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Título del reporte
                Text("Reporte seleccionado: \(reporte)")
                    .font(.title)
                    .padding()
                
                // Mostrar el ícono correspondiente al reporte
                Image(systemName: reporteIcon)
                    .font(.system(size: 50))
                    .foregroundColor(reporteColor)
                    .padding()
                
                // Campo de texto para el consejo
                TextField("💡 Agrega una descripción", text: $consejo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)  // Define el radio de los bordes
                            .stroke(Color.green, lineWidth: 2)  // Borde verde con grosor de 2
                    )
                
                // Slider de magnitud
                VStack {
                    Text("🌡️ Magnitud del evento")
                        .bold()
                    Slider(value: $magnitud, in: 1...10, step: 1)
                    Text("Nivel: \(Int(magnitud))")
                        .font(.caption)
                }
                .padding()
                
                // Seleccionar imagen (opcional)
                Text("📸 Adjuntar foto (opcional)")
                    .bold()
                Button("Seleccionar Imagen") {
                    showImagePicker = true
                }
                .padding()
                .foregroundColor(.white)
                .background(.cuarto)
                .cornerRadius(10)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                
                // Enlace para ir a la pantalla de selección de ubicación
                NavigationLink(destination: SeleccionarUbicacionView(selectedLocation: $selectedLocation, climaLocation: climaLocation ?? CLLocationCoordinate2D(latitude: 25.628752, longitude: -100.304039))) {
                    Text("📍 Seleccionar ubicación exacta")
                        .font(.body)
                        .foregroundColor(.tercero)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                // Mostrar la ubicación seleccionada en la pantalla principal (si existe)
                if let location = selectedLocation {
                    Text("Ubicación seleccionada: \(location.latitude), \(location.longitude)")
                        .padding()
                }
                
                // Botón de enviar reporte
                Button(action: {
                    // Aquí puedes manejar el envío del reporte
                }) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Enviar Reporte")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.cuarto)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .navigationTitle("Registrar Reporte")
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Registrar Reporte")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    Image("BiomaInicio2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30) // Ajusta el tamaño de la imagen según lo necesites
                }
            }
        }
    }
}
    
    struct RegistrarReporteView_Previews: PreviewProvider {
        static var previews: some View {
            let reportManager = ReportManager()
            RegistrarReporteView(reporte: "Incendio", reportManager: reportManager)
            RegistrarReporteView(reporte: "Inundación", reportManager: reportManager)
            RegistrarReporteView(reporte: "Árbol Caído", reportManager: reportManager)
            RegistrarReporteView(reporte: "Animal Suelto", reportManager: reportManager)
            RegistrarReporteView(reporte: "Otro", reportManager: reportManager)
        }
    }
    

