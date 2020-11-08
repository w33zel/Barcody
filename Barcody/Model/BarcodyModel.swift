//
//  BarcodyModel.swift
//  Barcody
//
//  Created by Christian Arlt on 08.11.20.
//

import SwiftUI

final class BarcodyModel: ObservableObject {
    @Published var scannedContent: Barcode?
    @Published var alertItem: AlertItem?
    @Published var captureSessionRunning = true
    @Published var startNewCaptureSession = false
    
    var statusText: String {
        scannedContent?.barcode ?? "No Barcode scanned"
    }
    
    var scannedObjectType: String {
        scannedContent?.type ?? ""
    }
    
    var statusTextColor: Color {
        if scannedContent?.barcode == nil {
            return .red
        }
        return .green
    }
}
