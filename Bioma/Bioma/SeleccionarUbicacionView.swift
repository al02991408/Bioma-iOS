import SwiftUI
import MapKit

// Estructura para hacer que CLLocationCoordinate2D sea Identifiable
struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct SeleccionarUbicacionView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?  // Para pasar la ubicación seleccionada de vuelta
    
    var climaLocation: CLLocationCoordinate2D  // La ubicación del clima desde la API
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.628752, longitude: -100.304039), // El Tecmi por defecto
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                userTrackingMode: $userTrackingMode,
                annotationItems: selectedLocation != nil ? [IdentifiableLocation(coordinate: selectedLocation!)] : []
            ) { location in
                MapPin(coordinate: location.coordinate, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)
            .gesture(
                TapGesture()
                    .onEnded { value in
                        // Calcula la ubicación donde se tocó en el mapa
                        let tappedCoordinate = region.center
                        selectedLocation = tappedCoordinate  // Actualizamos la ubicación seleccionada
                        region.center = tappedCoordinate // Actualiza la región para centrarse en la nueva ubicación
                    }
            )

            HStack {
                Button("Ubicación actual") {
                    // Centra el mapa en la ubicación obtenida desde la API del clima
                    region.center = climaLocation
                    userTrackingMode = .follow
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Confirmar Ubicación") {
                    // Aquí puedes manejar la lógica de confirmación
                    print("Ubicación confirmada: \(selectedLocation?.latitude ?? 0), \(selectedLocation?.longitude ?? 0)")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            // Al aparecer la vista, centramos el mapa en la ubicación del clima
            region.center = climaLocation
        }
        .navigationTitle("Seleccionar Ubicación")
    }
}

struct SeleccionarUbicacionView_Previews: PreviewProvider {
    static var previews: some View {
        // Simulamos una ubicación obtenida de la API de clima (por ejemplo Monterrey)
        SeleccionarUbicacionView(selectedLocation: .constant(nil), climaLocation: CLLocationCoordinate2D(latitude: 25.628752, longitude: -100.304039))
    }
}
