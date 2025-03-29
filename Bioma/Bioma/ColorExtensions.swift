//
//  ColorExtensions.swift
//  bioma
//
//  Created by Alumno on 28/03/25.
//
import SwiftUI

// Colores para la interfaz (paleta de verdes)
extension Color {
    static let colorFondo = Color(hex: "#FBF6E9") // Fondo claro
    static let colorVerdeClaro = Color(hex: "#C1E1C1") // Verde claro
    static let colorVerdeMedio = Color(hex: "#5DB996") // Verde medio
    static let colorVerdeOscuro = Color(hex: "#118B50") // Verde oscuro
}

// Extensión para convertir colores hexadecimales a UIColor/Color en SwiftUI
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
