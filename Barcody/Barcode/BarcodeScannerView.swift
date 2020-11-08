//
//  ContentView.swift
//  Barcody
//
//  Created by Christian Arlt on 07.11.20.
//

import SwiftUI

struct BarcodeScannerView: View {
    @StateObject var model = BarcodyModel()
    
    var body: some View {
        NavigationView {
            VStack {
//                Rectangle()
                ScannerView(model: model)
                    .aspectRatio(1.3, contentMode: .fit)

                Label("Scaned Barcode", systemImage: "barcode.viewfinder")
                    .padding(.top)
                    .font(.title)
                
                Text(model.scannedObjectType)
                    .font(.subheadline)
                                
                Text(model.statusText)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(model.statusTextColor)
                    .padding()
                if !model.captureSessionRunning {
                    Button(action: {
                        model.scannedContent = nil
                        model.startNewCaptureSession = true
                    }, label: {
                        Text("Scann other code...")
                            .font(.title2)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    })
                }
            }
            .navigationTitle("Barcody")
            .alert(item: $model.alertItem) { item in
                Alert(title: item.title, message: item.message, dismissButton: item.dismissButton)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
