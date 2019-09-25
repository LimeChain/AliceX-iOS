//
//  WalletConnectServerHandler.swift
//  AliceX
//
//  Created by lmcmz on 24/9/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import WalletConnectSwift

class WCHandler: RequestHandler {
    
    weak var server: Server!
    
    init(server: Server) {
        self.server = server
    }

    func canHandle(request: Request) -> Bool {
        return false
    }

    func handle(request: Request) {
        // to override
    }
}

class SignTransactionHandler: WCHandler {
    
    override func canHandle(request: Request) -> Bool {
        return request.method == "eth_signTransaction"
    }
    
    override func handle(request: Request) {
    }
    
}

class PersonalSignHandler: WCHandler {

    override func canHandle(request: Request) -> Bool {
        return request.method == "personal_sign"
    }
    
    override func handle(request: Request) {
        do {
            
            var messageBytes = try request.parameter(of: String.self, at: 0)
            var address = try request.parameter(of: String.self, at: 1)
            
            // TODO: Change way to mach
            if address.count != 42 {
                swap(&address, &messageBytes)
            }
            
            if address.lowercased() != WalletManager.wallet?.address.lowercased() {
               server.send(.reject(request))
                HUDManager.shared.showError(text: "Address Not Matched")
               return
           }

            guard let decodedMessage = messageBytes.hexDecodeUTF8 else {
                server.send(.reject(request))
                HUDManager.shared.showError(text: "Message decode failed")
                return
            }
            
            onMainThread {
                
                let info = WCServerHelper.shared.dappInfo
                
                let name = info?.url.host ?? "Dapp"
                
                let view = WCPopUp.make(logo: info?.icons.first,
                                        name: name,
                                        title: "Request To Sign Message",
                                        content: "<alice>Alice</alice> received a request from <blue>\(name)</blue>, if that is not your operation.\nPlease <red>reject</red> it.",
                                        comfirmBlock: {
                                            self.signMessage(request: request, message: messageBytes)
                }) {
                    self.server.send(.reject(request))
                }
                           
               HUDManager.shared.showAlertView(view: view,
                                               backgroundColor: .clear,
                                               haptic: .none,
                                               type: .bottomFloat,
                                               widthIsFull: true,
                                               canDismiss: false)
            }
            
//            let signed = try TransactionManager.signMessage(message: Data.fromHex(messageBytes)!)
       } catch {
           server.send(.invalid(request))
           return
       }
    }
    
    func signMessage(request: Request, message: String) {
        TransactionManager.showSignMessageView(message: message) { (signed) in
            let response = try! Response(url: request.url, value: signed, id: request.id!)
            self.server.send(response)
        }
    }
}
