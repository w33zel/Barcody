//
//  ScannerVC.swift
//  Barcody
//
//  Created by Christian Arlt on 07.11.20.
//

import UIKit
import AVFoundation


enum CameraError {
    case invalideDeviceInput
    case invalideScannedValue
    case codeNotSupported
}

protocol ScannerVCDelegate: class {
    func didFindBarcode(_ barcode: Barcode)
    func didSurface(error: CameraError)
    func stopCaptureSession()
}

final class ScannerVC: UIViewController {
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?

    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalideDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    func startNewCaptureSession() {
        print("startNewCaptureSession")
        captureSession.startRunning()
    }
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalideDeviceInput)
            return
        }

        var videoInput: AVCaptureDeviceInput

        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalideDeviceInput)
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalideDeviceInput)
            return
        }

        let metaDataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr, .face]
        } else {
            scannerDelegate?.didSurface(error: .invalideDeviceInput)
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        startNewCaptureSession()
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print(metadataObjects)
        guard let object = metadataObjects.first else {
//            scannerDelegate?.didSurface(error: .invalideScannedValue)
            return
        }
        
        switch object {
        case let machineReadable as AVMetadataMachineReadableCodeObject:
            if machineReadable.type == .ean8 || machineReadable.type == .ean13 {
                let bc = Barcode(type: machineReadable.type.rawValue, barcode: machineReadable.stringValue ?? "")
                scannerDelegate?.didFindBarcode(bc)
            } else {
                scannerDelegate?.didSurface(error: .codeNotSupported)
            }
        case let face as AVMetadataFaceObject:
            let bc = Barcode(type: face.type.rawValue, barcode: "👩 I found a face. 👱‍♂️")
            scannerDelegate?.didFindBarcode(bc)
        default:
            scannerDelegate?.didSurface(error: .invalideScannedValue)
        }
        
        scannerDelegate?.stopCaptureSession()
        captureSession.stopRunning()
        print("Capturesession stopped")
    }
}
