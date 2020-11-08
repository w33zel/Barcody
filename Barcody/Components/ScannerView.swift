//
//  ScannerView.swift
//  Barcody
//
//  Created by Christian Arlt on 08.11.20.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @ObservedObject var model: BarcodyModel
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(view: self)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
        if !model.captureSessionRunning && model.startNewCaptureSession {
            model.captureSessionRunning = true
            model.startNewCaptureSession = false
            uiViewController.startNewCaptureSession()
        }
    }

}

extension ScannerView {
    final class Coordinator: NSObject, ScannerVCDelegate {

        private let view: ScannerView
        
        init(view: ScannerView) {
            self.view = view
        }
        
        func didFindBarcode(_ barcode: Barcode) {
            view.model.scannedContent = barcode
        }
                
        func didSurface(error: CameraError) {
            switch error {
            case .invalideDeviceInput:
                view.model.alertItem = AlertContext.invalideDeviceInput
            case .invalideScannedValue:
                view.model.alertItem = AlertContext.invalideScannedValue
            case .codeNotSupported:
                view.model.alertItem = AlertContext.codeNotSupported
            }
        }
                
        func stopCaptureSession() {
            print("stopCaptureSession - ScannerView")
            view.model.captureSessionRunning = false
        }
    }
}
