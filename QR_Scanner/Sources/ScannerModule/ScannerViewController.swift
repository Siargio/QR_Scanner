//
//  ScannerViewController.swift
//  QR_Scanner
//
//  Created by Sergio on 6.03.23.
//

import UIKit
import AVFoundation

// MARK: - Protocols

protocol ScannerViewProtocol: AnyObject {
    func goToWebController(url: String)
}

// MARK: - Class

final class ScannerViewController: UIViewController {

    //MARK: - Properties

    var presenter: ScannerPresenterProtocol?
    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        outputCheck()
    }

    //MARK: - Setups

    private func initialSetup() {
        self.navigationController?.navigationBar.isHidden = true
        sessionSetup()
        runSession()
    }

    private func sessionSetup() {
        guard let device = AVCaptureDevice.default(for: .video ) else { showAlert(title: Strings.alertTitle, message: Strings.alertMessage)
            return
        }
        session.sessionPreset = AVCaptureSession.Preset.high
        do {
            try session.addInput(AVCaptureDeviceInput(device: device))
        }
        catch {
            fatalError(error.localizedDescription)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.layer.bounds
        view.layer.addSublayer(previewLayer)

        startSession()
    }

    private func outputCheck(){
        guard session.canAddOutput(metadataOutput) else {
            startSession()
            return
        }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
    }

    private func runSession() {
        guard !session.isRunning else { return }
        startSession()
    }

    private func startSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }
}

//MARK: - AVCaptureMetadataOutputObjects Delegate Method

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let url = readableObject.stringValue else { return }
            goToWebController(url: url)
        }
        session.stopRunning()
    }
}

//MARK: - Navigation

extension ScannerViewController: ScannerViewProtocol {

    func goToWebController(url: String) {
        presenter?.goToWebsite(url: url)
    }
}

// MARK: - Appearance

extension ScannerViewController {

    private enum Strings {
        static let alertActionTitle = "Ok"
        static let alertTitle = "Ошибка!"
        static let alertMessage = "Камера не доступна!"
    }
}
