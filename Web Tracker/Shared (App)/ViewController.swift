//
//  ViewController.swift
//  Shared (App)
//
//  Created by Eno Dynowski on 10/21/21.
//

import WebKit
import AppTrackingTransparency

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController
#endif

let extensionBundleIdentifier = "com.yourCompany.Web-Tracker.Extension"

class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!
    //private var deniedView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deniedView.isHidden = true
        
        // ATT button
        let button = UIButton (frame: CGRect(x:(view.center.x - 150), y:(view.center.y - 200), width: 300, height: 50))
        
        view.addSubview(button)
        //ATT button location
        button.center = view.center
        button.translatesAutoresizingMaskIntoConstraints = false


        
        //ATT button styling
        button.setTitle("Get Data Collection Permission", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "buttonBackground")
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
        
        
        
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        self.webView.navigationDelegate = self

#if os(iOS)
        self.webView.scrollView.isScrollEnabled = false
#endif

        self.webView.configuration.userContentController.add(self, name: "controller")

        self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
    }
    
    
    
    
    
    @objc func didTapButton() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                //do a thing
                print("denied")
                break
            case .authorized:
                //do a thing
                print("allowed")
                break
            @unknown default:
                break
            }
        }
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
#if os(iOS)
        webView.evaluateJavaScript("show('ios')")
#elseif os(macOS)
        webView.evaluateJavaScript("show('mac')")

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                webView.evaluateJavaScript("show('mac', \(state.isEnabled)")
            }
        }
#endif
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
#if os(macOS)
        if (message.body as! String != "open-preferences") {
            return;
        }

        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                NSApplication.shared.terminate(nil)
            }
        }
#endif
    }

}
