//
//  ViewController.swift
//  QRCodeSwift
//
//  Created by 강대민 on 2022/06/20.
//

import UIKit
import WebKit
import AVFoundation
import QRCodeReader

class MainViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var qecodeBtn: UIButton!
    
    //QR코드 리더 뷰컨트롤러 생성.
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        // webkit에서 주의할점은 https://를 안쓰면 안된다.
        let url = URL (string: "https://www.naver.com")
        let requestObj = URLRequest(url:url!)
        webView.load(requestObj)
    
        qecodeBtn.layer.borderWidth = 3
        qecodeBtn.layer.borderColor = UIColor.blue.cgColor
        qecodeBtn.layer.cornerRadius = 10
        qecodeBtn.addTarget(self, action: #selector(qrcodeRead), for: .touchUpInside)
        
    }
    
    //MARK: - fileprivate 메소드
    @objc fileprivate func qrcodeRead() {
        print("MainViewController - 큐알코드리더 호출")
        readerVC.delegate = self

        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
          //print(result)
            
            guard let scanUrl = result?.value else { return
                print("qr코드 에러")
            }
            print("scanUrl : \(scanUrl)")
            let scannedUrl = URL(string: scanUrl)
            self.webView.load(URLRequest(url: scannedUrl!))
            
        }
        //화면을 어떻게 띄울것인지 정하고
        readerVC.modalPresentationStyle = .formSheet
        //화면을 띄우기.
        present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: - QR코드 델리게이트 메소드
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

}

