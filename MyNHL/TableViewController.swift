//
//  TableViewController.swift
//  MyNHL
//
//  Created by Polina on 10/29/19.
//  Copyright © 2019 harinovskaya. All rights reserved.
//

import UIKit
import Foundation

//https://statsapi.web.nhl.com/api/v1/standings/byLeague

class TableViewController: UIViewController {

    @IBOutlet weak var teamsTable: UITableView!
    var pointsArr = [Int]()
    var diffArr = [Int]()
    var idArr = [Int]()
    var teamsNamesArray = [String]()
    
    
   // MARK: - structs json
    struct Welcome: Codable {
       let records: [Record]
   }
   struct Record: Codable {
       let teamRecords: [TeamRecord]
   }
   struct League: Codable {
        let id: Int
       let name: String
   }
   struct TeamRecord: Codable {
       let team: League
       let goalsAgainst, goalsScored, points: Int
   }
    


//MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientBackground()
        
        getJSON()
        teamsTable.dataSource = self
        teamsTable.delegate = self
      }
 
//MARK: - getJSON
    func getJSON() {
           let url = URL(string: "https://statsapi.web.nhl.com/api/v1/standings/byLeague")!
             URLSession.shared.dataTask(with: url) { (data, response, err) in
                     if let data = data {
                        DispatchQueue.main.async {
                            let myData = try? JSONDecoder().decode(Welcome.self, from: data)
                            for i in 0..<myData!.records[0].teamRecords.count {
                                self.teamsNamesArray.append(myData!.records[0].teamRecords[i].team.name)
                                self.pointsArr.append(myData!.records[0].teamRecords[i].points)
                                self.diffArr.append(myData!.records[0].teamRecords[i].goalsScored - myData!.records[0].teamRecords[i].goalsAgainst)
                                self.idArr.append(myData!.records[0].teamRecords[i].team.id)
                            }
                        self.teamsTable.reloadData()
                        }
                     }
             }.resume()
}
      
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "tableTeamSegue" {
        if self.teamsTable.indexPathForSelectedRow != nil {
                    let destinationVC = segue.destination as! TeamViewController
                    destinationVC.id = self.idArr[self.teamsTable.indexPathForSelectedRow!.row]
                  }
        }
}

 //MARK: - Interface
    public func gradientBackground() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.gray.cgColor, UIColor.black.cgColor]
        view.layer.addSublayer(layer)
        layer.zPosition = -1
    }
}

//MARK: - TeamsTable Protocols extension
extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamsCellID", for: indexPath) as! TeamsTableViewCell
        cell.teamsLA?.text = "\(indexPath.row+1). \(teamsNamesArray[indexPath.row])"
        cell.pointsLA?.text = "\(pointsArr[indexPath.row])"
        if diffArr[indexPath.row] > 0 {
            cell.diffLA.textColor = UIColor.green
        } else if diffArr[indexPath.row] < 0 {
            cell.diffLA.textColor = UIColor.red
        } else { cell.diffLA.textColor = UIColor.gray }
        cell.backgroundColor = UIColor.clear
        cell.diffLA?.text =  "\(diffArr[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:100))
        
        let labelT = UILabel(frame: CGRect(x:20, y:5, width:tableView.frame.size.width, height:30))
        labelT.font = UIFont.boldSystemFont(ofSize: 22)
        labelT.text = "Teams";
        labelT.textColor = UIColor.white
        
        let labelP = UILabel(frame: CGRect(x:tableView.frame.size.width-90, y:5, width:tableView.frame.size.width, height:30))
        labelP.font = UIFont.systemFont(ofSize: 22)
        labelP.text = "P";
        labelP.textColor = UIColor.white
        
        let labelD = UILabel(frame: CGRect(x:tableView.frame.size.width-50, y:5, width:tableView.frame.size.width, height:30))
        labelD.font = UIFont.systemFont(ofSize: 22)
        labelD.text = "Diff";
        labelD.textColor = UIColor.white
        
        view.addSubview(labelT);
        view.addSubview(labelP);
        view.addSubview(labelD);
        
    
             view.backgroundColor = UIColor.black;
             return view
    }
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
 
}
