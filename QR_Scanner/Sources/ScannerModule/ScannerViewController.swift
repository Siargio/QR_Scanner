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

    // MARK: - Constants
    private enum Constants {
        static let ofSizeFont: CGFloat = 24
        static let outerPathCornerRadius: CGFloat = 30
        static let rectWidth: CGFloat = 1.4
        static let two: CGFloat = 2
        static let toValue = 1.05
        static let duration = 1.1
        static let InfoLabelTopAnchor: CGFloat = 60
        static let cornersImageWidth: CGFloat = 0.85
        static let cornersImageHeight: CGFloat = 0.42
    }

    private enum Strings {
        static let infoLabelText = "Find a code to scan"
        static let cornersImage = UIImage(named: "corners")
        static let keyPath = "transform.scale"
        static let forKey = "animate"
        static let cameraMissing = "camera missing"
    }

    //MARK: - Properties
    var presenter: ScannerPresenterProtocol?
    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()

    //MARK: - UIElements
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.ofSizeFont)
        label.textColor = .white
        label.text = Strings.infoLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cornersImage: UIImageView = {
        let image = Strings.cornersImage
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewDidAppearSetup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cornersImage.layer.removeAllAnimations()
    }

    //MARK: - Setups
    private func initialSetup() {
        self.navigationController?.navigationBar.isHidden = true
        sessionSetup()
        addBlur()
        runSession()
        setupHierarchy()
        setupLayout()
    }

    private func viewDidAppearSetup() {
        outputCheck()
        animateCorner()
    }

    private func setupHierarchy() {
        view.addSubview(infoLabel)
        view.addSubview(cornersImage)
    }

    private func addBlur() {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let scanLayer = CAShapeLayer()
        let maskSize = getMaskSize()
        let outerPath = UIBezierPath(roundedRect: maskSize, cornerRadius: Constants.outerPathCornerRadius)

        let superLayerPath = UIBezierPath(rect: blurView.frame)
        outerPath.append(superLayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = .evenOdd

        view.addSubview(blurView)
        blurView.layer.mask = scanLayer
    }

    // Get mask size respect to screen size, For `Dynamic` CameraView Size
    private func getMaskSize() -> CGRect {
        let viewWidth = view.frame.width
        let rectWidth = viewWidth / Constants.rectWidth
        let halfWidth = rectWidth / Constants.two
        let x = view.center.x - halfWidth
        let y = view.center.y - halfWidth
        return CGRect(x: x, y: y, width: rectWidth, height: rectWidth)
    }

    private func animateCorner() {
        let animation = CABasicAnimation(keyPath: Strings.keyPath)
        animation.toValue = Constants.toValue
        animation.duration = Constants.duration
        animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        cornersImage.layer.add(animation, forKey: Strings.forKey)
    }

    //MARK: - Setup camera session
    private func sessionSetup() {
        guard let device = AVCaptureDevice.default(for: .video ) else { errorAlert(Strings.cameraMissing)
            return
        }
        session.sessionPreset = AVCaptureSession.Preset.high
        do {
            try session.addInput(AVCaptureDeviceInput(device: device))
        }
        catch {
            errorAlert(error.localizedDescription)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.layer.bounds
        view.layer.addSublayer(previewLayer)

        startSession()
    }

    //Check output
    private func outputCheck(){
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            startSession()
        }
    }

    //Return to session
    private func runSession() {
        if !session.isRunning {
            startSession()
        }
    }

    private func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
}

//MARK: - AVCaptureMetadataOutputObjects Delegate Method
extension ScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let url = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            goToWebController(url: url)
        }
        session.stopRunning()
    }
}

//MARK: - Alert Functions
extension ScannerViewController {
    /// Alert shown when qr scan
    func errorAlert(_ message: String) {
        let alert = UIAlertController(title: "Uh no!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "return", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true)
    }
}

//MARK: - ScannerViewProtocol
extension ScannerViewController: ScannerViewProtocol {
    //MARK: - NAVIGATION
    func goToWebController(url: String) {
        presenter?.goToWebsite(url: url)
    }
}

//MARK: - Constraint
extension ScannerViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.InfoLabelTopAnchor),

            cornersImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cornersImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cornersImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.cornersImageWidth),
            cornersImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Constants.cornersImageHeight)
        ])
    }
}
