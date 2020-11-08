//
//  Alerts.swift
//  Barcody
//
//  Created by Christian Arlt on 08.11.20.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalideDeviceInput = AlertItem(title: Text("Invalide Device Input"), message: Text("Something is wrong with the Camara. We are unable to capture the input."), dismissButton: .default(Text("OK")))
    
    static let invalideScannedValue = AlertItem(title: Text("Invalide Scanned Value"), message: Text("The value scanned is not valide. This App scanns EAN-8, EAN-13 and QR-Codes."), dismissButton: .default(Text("OK")))

    static let codeNotSupported = AlertItem(title: Text("Code Not Supported"), message: Text("The scanned code is not supported yet."), dismissButton: .default(Text("OK")))
}
