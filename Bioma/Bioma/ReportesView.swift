//
//  ReportView.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 28/03/25.
//
import SwiftUI

struct ReportesView: View {
    // Creamos el @StateObject para ReportManager
    @StateObject var reportManager = ReportManager()  // Usamos @StateObject para que se mantenga vivo en la vista
    let reportes = ["Incendio", "Árbol Caído", "Inundación", "Animal Suelto", "Otro"]
    
    // Función para obtener el ícono y el color según el tipo de reporte
    func getIcon(for reporte: String) -> (String, Color) {
        switch reporte {
        case "Incendio":
            return ("flame.fill", .red)
        case "Árbol Caído":
            return ("leaf.fill", .green)
        case "Inundación":
            return ("water.waves", .blue)
        case "Animal Suelto":
            return ("pawprint.fill", .brown)
        default:
            return ("exclamationmark.triangle.fill", .yellow)
        }
    }
    
    var body: some View {
        NavigationView {
            List(reportes, id: \.self) { reporte in
                NavigationLink(destination: RegistrarReporteView(reporte: reporte, reportManager: reportManager)) {  // Pasamos reportManager
                    HStack {
                        // Usamos la función para obtener el ícono y el color
                        let (iconName, iconColor) = getIcon(for: reporte)
                        Image(systemName: iconName)
                            .foregroundColor(iconColor)  // Asignamos el color al ícono
                        Text(reporte)
                    }
                    .padding(5)
                }
            }
            .navigationTitle("Reportes")
        }
    }
}

struct ReportesView_Previews: PreviewProvider {
    static var previews: some View {
        ReportesView()
    }
}

