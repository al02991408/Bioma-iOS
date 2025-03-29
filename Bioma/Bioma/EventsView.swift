import SwiftUI

// Modelo para eventos con categoría, calidad del aire y recomendación
struct Event: Identifiable {
    let id = UUID() // Identificador único del evento
    let title: String // Título del evento
    let date: Date // Fecha del evento
    let location: String // Ubicación del evento
    let description: String // Descripción del evento
    let category: String // Categoría del evento (e.g., Reforestación, Limpieza)
    let airQuality: String // Calidad del aire para el evento
    let recommendation: String // Recomendación para los participantes
}

// Datos de ejemplo de eventos
let sampleEvents: [Event] = [
    Event(title: "Reforestación Urbana 🌳", date: Date(), location: "Parque Fundidora", description: "Plantación de árboles en zonas urbanas.", category: "Reforestación", airQuality: "Buena", recommendation: "¡Perfecto para disfrutar del aire fresco! 🌿"),
    Event(title: "Limpieza de Ríos 🏞️", date: Date(), location: "Río Santa Catarina", description: "Retiro de desechos del río.", category: "Limpieza", airQuality: "Moderada", recommendation: "No recomendado si tienes problemas respiratorios. 😷"),
    Event(title: "Charla de Cambio Climático 🌎", date: Date(), location: "Evento en línea", description: "Expertos explican los efectos del cambio climático.", category: "Educación", airQuality: "Mala", recommendation: "Recomendado para todos. Puedes participar desde casa. 💻")
]

// Vista de eventos ecológicos
struct EventsView: View {
    @State private var selectedDate = Date() // Fecha seleccionada para mostrar los eventos
    @State private var userPoints = 250 // Puntos de usuario ejemplo
    @State private var showAlert = false // Para mostrar la alerta de calidad de aire
    @State private var registrationStatus: String? = nil // Mensaje de estado de registro
    @State private var showRegistrationAlert = false // Alerta de registro

    var body: some View {
        NavigationView {
            VStack {
                // Selector de fecha para filtrar eventos
                DatePicker("Selecciona una fecha", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(Color("Secundario").opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                
                // Lista de eventos filtrados por fecha seleccionada
                List(sampleEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) { event in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(event.title).font(.headline)
                            .foregroundColor(Color("Tercero"))
                        Text(event.location).font(.subheadline)
                            .foregroundColor(Color("Cuarto"))
                        Text("Calidad del aire: \(event.airQuality)").font(.footnote).foregroundColor(Color("Tercero"))
                        Text(event.description).font(.body)
                            .foregroundColor(.primary)
                        Text(event.recommendation).font(.subheadline).italic().foregroundColor(Color("Tercero"))
                        
                        Button(action: {
                            self.registerForEvent(event)
                        }) {
                            Text("Registrarse 📅")
                                .foregroundColor(.cuarto)
                                .padding()
                                .background(Color("Primario"))
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                        .padding(.top, 5)
                        
                        // Estado de registro (confirmación o advertencia)
                        if let status = registrationStatus {
                            Text(status)
                                .font(.footnote)
                                .foregroundColor(status == "Registrado con éxito 🎉" ? .green : .red)
                                .padding(.top, 5)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("Primero").opacity(0.1)))
                    .padding(.horizontal)
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "leaf.fill")  // Puedes usar cualquier otro símbolo que prefieras
                            .foregroundColor(.green)
                            .font(.system(size: 18)) // Tamaño más pequeño

                        Text("Eventos Ecológicos")
                            .font(.system(size: 20, weight: .bold)) // Tamaño más pequeño para el texto
                            .foregroundColor(.tercero)
                    }
                }
            }
            .alert(isPresented: $showRegistrationAlert) {
                // Alerta cuando la calidad del aire es mala y el evento está al aire libre
                Alert(title: Text("¡Advertencia!"), message: Text("La calidad del aire es mala para este evento al aire libre. ¿Aún deseas registrarte?"), primaryButton: .default(Text("Sí")) {
                    self.registerForEvent(sampleEvents[2]) // Evento con calidad de aire mala
                }, secondaryButton: .cancel())
            }
        }
    }
    
    // Función para registrar al usuario en un evento y agregar puntos
    private func registerForEvent(_ event: Event) {
        if event.location.lowercased().contains("en línea") || event.location.lowercased().contains("casa") {
            // Si el evento es en línea o en casa, no mostramos advertencia por calidad de aire
            userPoints += (event.airQuality == "Buena") ? 20 : 10
            registrationStatus = "Registrado con éxito 🎉"
        } else {
            // Verificamos la calidad del aire solo para eventos al aire libre
            if event.airQuality == "Buena" {
                userPoints += 20
                registrationStatus = "Registrado con éxito 🎉"
            } else if event.airQuality == "Moderada" {
                userPoints += 10
                registrationStatus = "Registrado, pero cuidado con la calidad del aire ⚠️"
            } else {
                registrationStatus = "El evento no es recomendable debido a la calidad del aire. ❌"
                showRegistrationAlert = true
            }
        }
    }
}
