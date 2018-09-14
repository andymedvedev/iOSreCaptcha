//
//  ViewController.swift
//  TestReCaptcha
//
//  Created by Andrey Medvedev on 13.09.2018.
//  Copyright © 2018 Betolimp. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var wk: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWebView()
        
        if let wk = wk {
            wk.loadHTMLString("<body></body>", baseURL: URL(string: "https://localhost")!)
        }
    }
    
    func initWebView() {
        let wkController = WKUserContentController()
        wkController.add(self, name: "reCaptchaiOS")
        wkController.addUserScript(readScript())
        
        let wkConfig = WKWebViewConfiguration()
        wkConfig.userContentController = wkController
        
        self.wk = WKWebView(frame: self.view.frame, configuration: wkConfig)
        self.wk?.backgroundColor = .clear
        self.wk?.isOpaque = false
    }
    
    func readScript() -> WKUserScript {
        let scriptSource = try! String(contentsOfFile: (Bundle.main.path(forResource: "script", ofType: "js"))!)
        return WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}


extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let args = message.body as? [String] {
            
            switch args[0] {
                
            case "didLoad":
                self.captchaDidLoad()
                break
                
            case "didSolve":
                self.captchaDidSolve(response: args[1])
                break
                
            case "didExpire":
                self.captchaDidExpire()
                break
                
            default:
                print("args[0]: \(args[0])")
                break
                
            }
        }
    }
    
    
    func captchaDidLoad() {
        if let wk = self.wk {
            wk.frame = self.view.frame
            self.view.addSubview(wk)
        } else {
            print("wk is null")
        }
    }
    
    func captchaDidSolve(response: String) {
        print("response: \(response)")
    }
    
    func captchaDidExpire() {
        print("Captcha Expired")
    }
}
