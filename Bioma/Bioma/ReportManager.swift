//
//  ReportManager.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 28/03/25.
//


import SwiftUI

class ReportManager: ObservableObject {
    @Published var reports: [Report] = []
    
    func addReport(report: Report) {
        reports.append(report)
    }
}
