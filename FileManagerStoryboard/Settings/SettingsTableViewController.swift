//
//  SettingsTableViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 13.09.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySwitch.isOn = true

    }
    
    @IBAction func mySwitch(_ sender: Any) {
        if (sender as! UISwitch).isOn {
            UserDefaults.standard.set("1", forKey: "sortAcs")
        } else {
            UserDefaults.standard.set("0", forKey: "sortAcs")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
             loginVC.mode = .changePassword

             navigationController?.present(loginVC, animated: true)
             tableView.deselectRow(at: indexPath, animated: false)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
   
}
