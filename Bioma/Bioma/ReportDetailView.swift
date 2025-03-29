//
//  ReportDetalilView.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 28/03/25.
//

import SwiftUI

struct ReportDetailView: View {
    let report: Report
    
    var body: some View {
        VStack {
            Text(report.title)
                .font(.title)
            
            // Aquí puedes mostrar más detalles del reporte
        }
    }
}
