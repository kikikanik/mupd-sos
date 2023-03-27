//
//  IncidentDetailViewController.swift
//  MUPD-SOS
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class IncidentChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userService = UserService.shared
    let profileService = ProfileService.shared
    let mupdprofileService = MUPDProfileService.shared
    let chatService = ChatService.shared
    
    var selectedIncident : PinDrop!
    var chat: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTable.delegate = self
        messagesTable.dataSource = self
        self.title = selectedIncident.userID
    }
    
    @IBOutlet weak var messagesTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(messagesReceived), name: Notification.Name(rawValue: kSOSMessagesChanged), object: nil)
        chatService.observeChat(notificationID: selectedIncident.pinDropId)
    }
    
    @objc
    func messagesReceived() {
        chat.removeAll()
        for message in chatService.chat {
            let message = Message(messageID: message.messageID, postedBy: message.postedBy, postedMessage: message.postedMessage)
            chat.append(message)
        }
        messagesTable.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath)

        let thisMessage = chat[indexPath.row]
        
        cell.textLabel?.text = thisMessage.postedBy
        cell.detailTextLabel?.text = thisMessage.postedMessage
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func timeInterval() -> String {
        let tnow = Date()
        var ts = String(tnow.timeIntervalSince1970)
        ts = ts.replacingOccurrences(of: ".", with: "")
        return ts
    }
    
    func getLongDateTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    } //end getLongDateTime

}
