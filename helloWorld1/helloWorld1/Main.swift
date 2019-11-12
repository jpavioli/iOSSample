//
//  Main.swift
//  helloWorld1
//
//  Created by Sue Chung on 10/23/19.
//  Copyright © 2019 Sue Chung. All rights reserved.
//

import Foundation
import UIKit
import mParticle_Apple_SDK
import WebKit

class MainViewController: UIViewController {
    
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
        
        let identityCallback = {(result: MPIdentityApiResult?, error: Error?) in
            if (result?.user != nil) {
                //IDSync request succeeded, mutate attributes or query for the MPID as needed
            } else {
                NSLog(error!.localizedDescription)
                let resultCode = MPIdentityErrorResponseCode(rawValue: UInt((error! as NSError).code))
                switch (resultCode!) {
                case .clientNoConnection,
                     .clientSideTimeout:
                    //retry the IDSync request
                    break;
                case .requestInProgress,
                     .retry:
                    //inspect your implementation if this occurs frequency
                    //otherwise retry the IDSync request
                    break;
                default:
                    // inspect error.localizedDescription to determine why the request failed
                    // this typically means an implementation issue
                    break;
                }
            }
        }
        MParticle.sharedInstance().identity.logout(MPIdentityApiRequest.withEmptyUser(),completion: identityCallback)
        // Force end a session
        //MParticle.sharedInstance().endSession()
        
    }
    
    @IBOutlet weak var textLabel: UITextField!
    
    var txt = ""
    
    func showText(){
        textLabel.text = txt
    }
    
    
    
    @IBAction func customEvent1(_ sender: Any) {
        let event = MPEvent(name: "EventZ", type: MPEventType.navigation)

        event?.customAttributes = ["eventAttribute": "eventValue"];

        if (event != nil) {
            MParticle.sharedInstance().logEvent(event!)
        }
        txt = "Event tapped"
        showText()
    }
    
    
    
    let currentUser = MParticle.sharedInstance().identity.currentUser;
    
    // 1. Create the products
    let chicken = MPProduct.init(name: "chicken",
                                 sku: "sku567",
                                 quantity: 1,
                                 price: 100.00)
    
    
    
    
    @IBAction func addCart(_ sender: Any) {
        if let cart = currentUser?.cart {
            cart.addProduct(chicken)
        }

        txt = "Added to Cart"
        showText()
    }
    
    @IBAction func removeCart(_ sender: Any) {
        if let cart = currentUser?.cart {
            cart.removeProduct(chicken)
        }

        txt = "Removed to Cart"
        showText()
    }
    
    @IBAction func purchaseButton(_ sender: Any) {
        // 2. Summarize the transaction
        let attributes = MPTransactionAttributes.init()
        attributes.transactionId = "transaction-1234"
        attributes.revenue = 210.00
        attributes.tax = 10.00
        
        // 3. Log a purchase with all items currently in the cart
        let commerce = MParticle.sharedInstance().commerce
        commerce.purchase(with: attributes,
                          clearCart: false)
        
        if let cart = currentUser?.cart {
            cart.clear()
        }
        
        txt = "Purchased Cart"
        showText()
    }
    
    @IBAction func attributeButton(_ sender: Any) {
        currentUser?.setUserAttribute("age", value: "26")
        currentUser?.setUserAttributeList("interests", values: ["music", "tennis", "animals"])
        
        txt = "Set Attributes"
        showText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showText()
    }
    
    // TESTING WEBVIEWS
//    @IBOutlet weak var webView: WKWebView!
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear( animated )
//        
//        //webView = WKWebView(frame: .zero,configuration: WKWebViewConfiguration())
//        MParticle.sharedInstance().initializeWKWebView(webView)
//        let url:URL = URL(string: "https://www.sueyoungchung.com")!
//        let urlRequest:URLRequest = URLRequest(url: url)
//        webView.load(urlRequest)
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
