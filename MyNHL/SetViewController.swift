//
//  SetViewController.swift
//  MyNHL
//
//  Created by Polina on 10/31/19.
//  Copyright © 2019 harinovskaya. All rights reserved.
//

import UIKit

protocol saveFaveDelegate {
    func saveFav(changedTeam: String, changedID: Int)
}
class SetViewController: UIViewController {
    
    
    @IBOutlet weak var teamPicker: UIPickerView!
    
    var teamsArr = [String]()
    var ids = [Int]()
    var changedID = 0
    var changedTeam = ""
    var delegate: saveFaveDelegate?
     // MARK: - struct for imgs
       struct Welcome: Codable {
           let teams: [Team]
       }
       struct Team: Codable {
            let id: Int
            let name: String
       }
//MARK: -view Did load
    override func viewDidLoad() {
        
        super.viewDidLoad()
        gradientBackground()
        
        teamPicker.dataSource = self
        teamPicker.delegate = self
      
        getJSONabb()
        
    }
    

   //MARK: - get teams list
          func getJSONabb() {
                 let url = URL(string: "https://statsapi.web.nhl.com/api/v1/teams")!
                   URLSession.shared.dataTask(with: url) { (data, response, err) in
                           if let data = data {
                            DispatchQueue.main.async {
                              let myData = try? JSONDecoder().decode(Welcome.self, from: data)
                              for i in 0..<myData!.teams.count {
                                self.teamsArr.append(myData!.teams[i].name)
                                self.ids.append(myData!.teams[i].id)
                              }
                                self.teamPicker.reloadAllComponents()
                            }
                           }
                   }.resume()
      }
  
//MARK: -return to VC
    @IBAction func saveButton(_ sender: UIButton) {
        delegate?.saveFav(changedTeam: changedTeam, changedID: changedID)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    
//MARK: -Interface
    func gradientBackground() {
        teamPicker.setValue(UIColor.white, forKey: "textColor")
        self.navigationController?.isNavigationBarHidden = true
        let layer = CAGradientLayer()
          layer.frame = view.bounds
          layer.colors = [UIColor.gray.cgColor, UIColor.black.cgColor]
          view.layer.addSublayer(layer)
        layer.zPosition = -1
        navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }

}

//MARK: -Picker protocols extension
extension SetViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamsArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamsArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changedTeam = teamsArr[row]
        changedID = ids[row]
    }
    
}
 
