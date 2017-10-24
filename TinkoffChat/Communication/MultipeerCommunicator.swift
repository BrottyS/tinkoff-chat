//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by BrottyS on 21.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    let kServiceType = "tinkoff-chat"
    let kLocalPeerId = MCPeerID(displayName: String(describing: UIDevice.current.identifierForVendor!))
    let kDiscoveryInfo = ["userName": "BrottyS"]
    
    weak var delegate: CommunicatorDelegate?
    var online: Bool = false
    
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    // [peerID.displayName: MCSession]
    private var sessions: [String: MCSession] = [:]
    
    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: kLocalPeerId,
                                                      discoveryInfo: kDiscoveryInfo,
                                                      serviceType: kServiceType)
        
        serviceBrowser = MCNearbyServiceBrowser(peer: kLocalPeerId,
                                                serviceType: kServiceType)
        
        super.init()
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        if let session = sessions[userID] {
            let peersToSend = session.connectedPeers.filter { peer in
                peer.displayName == userID
            }
            do {
                try session.send(string.data(using: .utf8)!, toPeers: peersToSend, with: .reliable)
                completionHandler?(true, nil)
            }
            catch let error {
                print("Error sending: \(error)")
            }
            
        } else {
            completionHandler?(false, nil)
            print("Did not found a session with userID: \(userID)")
        }
    }
    
    func sessionFor(_ remotePeerID: MCPeerID) -> MCSession {
        if let session = sessions[remotePeerID.displayName] {
            return session
        } else {
            let session = MCSession(peer: kLocalPeerId,
                                    securityIdentity: nil,
                                    encryptionPreference: .none)
            session.delegate = self
            sessions[remotePeerID.displayName] = session
            return sessions[remotePeerID.displayName]!
        }
    }
    
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        //invitationHandler(true, self.session)
        let session = sessionFor(peerID)
        invitationHandler(true, session)
    }
    
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID.displayName)")
        let session = sessionFor(peerID)
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID.displayName)")
        if let _ = sessions[peerID.displayName] {
            sessions[peerID.displayName] = nil
        }
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
}

extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("didChangeState:")
        
        switch state{
        case .connected:
            print("peer \(peerID) connected to session: \(session)")
            delegate?.didChangeUserStatus(userID: peerID.displayName, online: true)
            
        case .connecting:
            print("peer \(peerID) connecting to session: \(session)")
            delegate?.didChangeUserStatus(userID: peerID.displayName, online: false)
            
        default:
            print("peer \(peerID) did not connect to session: \(session)")
            delegate?.didChangeUserStatus(userID: peerID.displayName, online: false)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        let message = String(data: data, encoding: .utf8)!
        delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: kLocalPeerId.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
    
}
