//
//  PlayerSSViewController.swift
//  MyNHL
//
//  Created by Polina on 10/29/19.
//  Copyright © 2019 harinovskaya. All rights reserved.
//

import UIKit

class PlayerSSViewController: UIViewController {

    
    @IBOutlet weak var playersTable: UITableView!
    @IBOutlet weak var searchPlayerBar: NSLayoutConstraint!
    
    
    // MARK: - GetIDs
    struct Welcome: Codable {
        let teams: [Team]
    }
    struct Team: Codable {
        let name: String
        let roster: TeamRoster
    }
    struct TeamRoster: Codable {
        let roster: [RosterElement]
    }
    struct RosterElement: Codable {
        let person: Person
        // let jerseyNumber: String
        let position: Position
    }
    struct Position: Codable {
        let name: PositionName
    }
    enum PositionName: String, Codable {
        case center = "Center"
        case defenseman = "Defenseman"
        case goalie = "Goalie"
        case leftWing = "Left Wing"
        case rightWing = "Right Wing"
    }
    struct Person: Codable {
        let id: Int
        let fullName: String
    }
    var dictPlayers = [String:[String]]()
    var positionArr = [String]()
    var idArr = [String]()
    var teamNameArr = [String]()
    var playersArr = [String]()
    
   // var searchDict = [String:[String]]()
    var searchArr = [String]()
    var searching = false
   // var jerseyNumberArr = [String]()
    
  //MARK: - VDD
   override func viewDidLoad() {
       super.viewDidLoad()
    gradientBackground()
    getID()
    playersTable.delegate = self
    playersTable.dataSource = self
   
    
      }
//MARK: - get ids and teams
    func getID() {
        let url = URL(string: "https://statsapi.web.nhl.com/api/v1/teams?expand=team.roster")!
                    URLSession.shared.dataTask(with: url) { (data, response, err) in
                            if let data = data {
                                DispatchQueue.main.async {
                                   let myData = try? JSONDecoder().decode(Welcome.self, from: data)
                                for i in 0..<myData!.teams.count {
                                    for j in 0..<myData!.teams[i].roster.roster.count {
                                        self.idArr.append(myData!.teams[i].roster.roster[j].person.fullName)
                                        self.positionArr.append(myData!.teams[i].roster.roster[j].position.name.rawValue)
                                        self.playersArr.append("\(myData!.teams[i].roster.roster[j].person.fullName) (\(myData!.teams[i].name))")
                                        //self.jerseyNumberArr.append(myData!.teams[i].roster.roster[j].jerseyNumber)
                                    }
                                    self.dictPlayers[myData!.teams[i].name] = self.idArr
                                    self.teamNameArr.append(myData!.teams[i].name)
                                    self.idArr = [String]()
                               }
                                    self.playersTable.reloadData()
                            }
                        }
                    }.resume()
    }
    
    
    
//MARK: -Interface
    public func gradientBackground() {
        self.navigationController?.isNavigationBarHidden = true
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
        view.layer.addSublayer(layer)
        layer.zPosition = -1
    }
}
//MARK: -Extension table
extension PlayerSSViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            if searching {
                return 1
            } else {
                return dictPlayers.count
            }
       }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        headerView.backgroundColor = UIColor.black
        let label = UILabel(frame: CGRect(x:20, y:5, width:tableView.frame.size.width, height:40))
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = teamNameArr[section]
        label.textColor = UIColor.white
          if !searching {
        headerView.addSubview(label)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = teamNameArr[section]
        if searching {
            return searchArr.count
        } else {
            return dictPlayers[key]!.count
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCellID", for: indexPath)

        let key = teamNameArr[indexPath.section]
        
        cell.backgroundColor = UIColor.clear
        
        if searching {
            cell.textLabel?.text = "\(searchArr[indexPath.row])"
            cell.detailTextLabel?.text = ""
            
        } else {
            cell.textLabel?.text = "\(dictPlayers[key]![indexPath.row])"
            cell.detailTextLabel?.text = "\(positionArr[indexPath.row])"
        }
        
        return cell
    }
}

//MARK: -Extension searchbar
extension PlayerSSViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
      //  searchDict = dictPlayers.mapValues{ $0.filter { $0.range(of: searchText, options: .caseInsensitive) != nil  } }
       // searchArr = playersArr.filter({$0.prefix(searchText.count) == searchText})
        searchArr = playersArr.filter({$0.range(of: searchText, options: .caseInsensitive) != nil })
        searching = true
        playersTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        playersTable.reloadData()
    }
}
