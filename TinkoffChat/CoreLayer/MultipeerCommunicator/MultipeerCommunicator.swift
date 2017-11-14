//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by BrottyS on 21.10.2017.
//  Copyright © 2017 TCS. All rights reserved.
//

import MultipeerConnectivity

protocol ICommunicator: class {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: MultipeerCommunicatorDelegate? { get set }
    var online: Bool { get set }
    func localPeerDisplayName() -> String
    func getOnlineUsers() -> [UserServiceModel]
}

protocol MultipeerCommunicatorDelegate: class {
    // discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    // messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
    // status
    func didChangeUserStatus(userID: String, online: Bool)
}

class MultipeerCommunicator: NSObject, ICommunicator {
    let kServiceType = "tinkoff-chat"
    let kLocalPeerId = MCPeerID(displayName: String(describing: UIDevice.current.identifierForVendor!))
    let kDiscoveryInfo = ["userName": "BrottyS"]
    
    weak var delegate: MultipeerCommunicatorDelegate?
    var online: Bool = false
    
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    // [peerID.displayName: MCSession]
    private var sessions: [String: MCSession] = [:]
    
    private var onlineUsers: [UserServiceModel] = []
    
    private let messageSerializer: IMessageSerializer
    
    init(messageSerializer: IMessageSerializer) {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: kLocalPeerId,
                                                      discoveryInfo: kDiscoveryInfo,
                                                      serviceType: kServiceType)
        
        serviceBrowser = MCNearbyServiceBrowser(peer: kLocalPeerId,
                                                serviceType: kServiceType)
        
        self.messageSerializer = messageSerializer
        
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
        guard let session = sessions[userID] else {
            print("Did not found a session with userID: \(userID)")
            completionHandler?(false, nil)
            return
        }
        
        let peersToSend = session.connectedPeers.filter { peer in
            peer.displayName == userID
        }
        
        guard let serializedMessage = messageSerializer.serialize(text: string) else {
            print("Can't get serialized message")
            completionHandler?(false, nil)
            return
        }
        
        do {
            try session.send(serializedMessage, toPeers: peersToSend, with: .reliable)
            completionHandler?(true, nil)
        }
        catch {
            print("Error while message sending. \(error.localizedDescription)")
            completionHandler?(false, error)
        }
    }
    
    func localPeerDisplayName() -> String {
        return kLocalPeerId.displayName
    }
    
    func getOnlineUsers() -> [UserServiceModel] {
        return onlineUsers
    }
    
    // MARK: - Private methods
    
    private func sessionFor(_ remotePeerID: MCPeerID) -> MCSession {
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
    
    private func addOnlineUser(userID: String, userName: String?) {
        if !onlineUsers.contains(where: { $0.userID == userID }) {
            onlineUsers.append(UserServiceModel(userID: userID, userName: userName))
        }
    }
    
    private func removeOnlineUser(userID: String) {
        if let index = onlineUsers.index(where: { $0.userID == userID }) {
            onlineUsers.remove(at: index)
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
        
        let userID = peerID.displayName
        let userName = info?["userName"]
        addOnlineUser(userID: userID, userName: userName)
        delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID.displayName)")
        if let _ = sessions[peerID.displayName] {
            sessions[peerID.displayName] = nil
        }
        
        removeOnlineUser(userID: peerID.displayName)
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
}

extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("didChangeState:")
        
        switch state {
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
        guard let deserializedMessage = messageSerializer.deserialize(data: data) else {
            print("Can't get deserialized message")
            return
        }
        
        delegate?.didReceiveMessage(text: deserializedMessage, fromUser: peerID.displayName, toUser: kLocalPeerId.displayName)
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
