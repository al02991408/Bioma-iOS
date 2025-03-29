//
//  UserRanking.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 28/03/25.
//


//
//  CommunityView.swift
//  bioma
//
//  Created by Alumno on 28/03/25.
//

import SwiftUI

// Modelo para usuarios en el ranking con niveles y puntos
struct UserRanking: Identifiable {
    let id = UUID() // Identificador único del usuario
    let name: String // Nombre del usuario
    var points: Int // Puntos del usuario
    let level: String // Nivel del usuario (e.g., Eco-Guardián)
    let icon: String
    var recentActivities: [String] // Registro de actividades recientes
}

// Datos de ejemplo de usuarios
var sampleUsers: [UserRanking] = [
    UserRanking(name: "Dana Zertuche", points: 250, level: "Eco-Guardián", icon: "shield.lefthalf.filled", recentActivities: ["Participó en Reforestación", "Ganó 20 puntos"]),
    UserRanking(name: "Leonardo González", points: 180, level: "Eco-Explorador", icon: "globe", recentActivities: ["Limpieza de Ríos", "Ganó 10 puntos"]),
    UserRanking(name: "Daniela Escamilla", points: 120, level: "Eco-Aprendiz", icon: "leaf", recentActivities: ["Charla de Cambio Climático", "Ganó 15 puntos"])
]

// Vista de comunidad y gamificación
struct CommunityView: View {
    @State private var userPoints = 250 // Puntos de ejemplo de un usuario
    @State private var selectedUserIndex: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "trophy.fill") // Ícono de trofeo del sistema
                        .foregroundColor(.yellow) // Personaliza el color
                    Text("Ranking de Eco-Héroes")
                }
                .font(.title)
                .padding()
                .foregroundColor(.colorVerdeMedio)
                
                
                List(sampleUsers.sorted { $0.points > $1.points }) { user in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                                .foregroundColor(.primary)
                            Image(systemName: user.icon)
                                .foregroundColor(.tercero)
                            Text(user.level).font(.subheadline).foregroundColor(.gray)
                        }
                        Spacer()
                        Text("\(user.points) pts")
                            .foregroundColor(.colorVerdeOscuro)
                            .onTapGesture {
                                self.selectedUserIndex = sampleUsers.firstIndex(where: { $0.id == user.id })
                            }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.colorVerdeClaro))
                    .padding(.horizontal)
                }
                
                // Detalles del usuario seleccionado
                if let index = selectedUserIndex {
                    VStack {
                        Text("Detalles de \(sampleUsers[index].name)")
                            .font(.title2)
                            .padding(.top)
                        Text("Puntos: \(sampleUsers[index].points)")
                        Text("Nivel: \(sampleUsers[index].level)")
                        Button("Incrementar puntos") {
                            sampleUsers[index].points += 20
                            sampleUsers[index].recentActivities.append("Ganaste 20 puntos")
                        }
                        .padding()
                        .background(Color.colorVerdeMedio)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        
                        // Mostrar actividades recientes
                        Text("Actividades Recientes: ")
                            .font(.headline)
                            .padding(.top)
                        ForEach(sampleUsers[index].recentActivities, id: \.self) { activity in
                            Text("- \(activity)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline) // Modo de título en línea
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("BiomaInicio2") // Imagen del recurso
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30) // Ajusta el tamaño según lo necesites
                        Text("Comunidad")
                            .font(.headline)
                    }
                }
            }
        }
    }
}
