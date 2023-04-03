//
//  IncidentDetailViewController.swift
//  MUPD-SOS
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit
import FirebaseFirestore

class IncidentChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userService = UserService.shared
    let profileService = ProfileService.shared
    let mupdprofileService = MUPDProfileService.shared
    let chatService = ChatService.shared
    
    var selectedIncident : PinDrop!
    var chat: [Message] = []
    
    @IBOutlet weak var messagesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTable.delegate = self
        messagesTable.dataSource = self
        self.title = selectedIncident?.userID
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(messagesReceived), name: Notification.Name(rawValue: kSOSMessagesChanged), object: nil)
        chatService.observeChat(notificationID: selectedIncident!.pinDropId)
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

    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func convertTimestamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss.SSSS"
        let currentTime = dateFormatter.string(from: date)
        return currentTime
    }
    
    @IBOutlet weak var newMessage: UITextView!
    
    func confirmAlert() {
        let alert = UIAlertController(title: "Message", message: "Message Sent!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button is tapped.
            print("Ok button tapped");
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        //@IBAction func sendButton(_ sender: Any) {
        print("You have pressed the send button!")
       
        let messageID = convertTimestamp()
        
        let postedBy = userService.currentUser!.email
                
        let postedMessage = newMessage?.text

        let sentMessage = Message(messageID: messageID, postedBy: postedBy, postedMessage: postedMessage!)
        
        //chatService.addMessage(message: sentMessage, notificationID: selectedIncident.pinDropId)
        
        chatService.addMessageMaybe(message: sentMessage, notificationID: selectedIncident.pinDropId, docID: convertTimestamp())
        
        confirmAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if selectedIncident != nil {
            if(segue.identifier == "profileSegue") {
                let dvc = segue.destination as! ProfileViewController
                dvc.selectedUserID = selectedIncident.userID
                print("reporter's doc id & email: ")
                print(selectedIncident!.userID)
                print("reporter's doc id & email local: ")
                print(dvc.selectedUserID)
            }
        }
    }
}
