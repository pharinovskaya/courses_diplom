//
//  TeamViewController.swift
//  MyNHL
//
//  Created by Polina on 10/29/19.
//  Copyright © 2019 harinovskaya. All rights reserved.
//

import UIKit
import Foundation
//https://statsapi.web.nhl.com/api/v1/teams/?expand=team.stats

class TeamViewController: UIViewController {

    @IBOutlet weak var iconTeam: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var conferenceLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var firstYearLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmControl: UISegmentedControl!
    let cellID = "statsCell"
    var id: Int = 0
    var firstArr = [String]()
    var secondArr = [String]()
    var secondArrJersey = [String]()
    var thirdArr = [String]()
  
    

    // MARK: - lets for stats
    struct Welcome: Codable {
        let teams: [Team]
    }
    struct Team: Codable {
        let venue: Venue
        let firstYearOfPlay: String
        let id: Int
        let name: String
        let abbreviation: String
        let division: Division
        let conference: Conference
        let teamStats: [TeamStat]
    }
    struct Conference: Codable {
        let name: String
    }
    struct Division: Codable {
       let name: String
    }
    struct TeamStat: Codable {
        let splits: [Split]
    }
    struct Split: Codable {
        let stat: Stat
    }
    struct Stat: Codable {
        let gamesPlayed: Int?
        let powerPlayPercentage: String
        let penaltyKillPercentage: String
        let faceOffWinPercentage: String
        let shootingPctg, savePctg: Double?
        let savePctRank, shootingPctRank: String?
    }
    struct Venue: Codable {
        let name: String
    }

//MARK: -lets for roster
    struct Welcome2: Codable {
        let teams: [Team2]
    }
    struct Team2: Codable {
        let roster: TeamRoster
    }
    struct TeamRoster: Codable {
        let roster: [RosterElement]
    }
    struct RosterElement: Codable {
        let person: Person
        let jerseyNumber: String
    }
    struct Person: Codable {
        let fullName: String
    }

// MARK: - Get info last game
    struct Welcome3: Codable {
        let teams: [Team3]
    }
    struct Team3: Codable {
        let previousGameSchedule: PreviousGameSchedule
    }
    struct PreviousGameSchedule: Codable {
        let dates: [DateElement]
    }

    struct DateElement: Codable {
        let date: String
        let games: [Game]
    }
    struct Game: Codable {
        let teams: Teams
    }
    struct Teams: Codable {
        let away, home: Away
    }
    struct Away: Codable {
        let team: Conference3
        let score: Int
    }
    struct Conference3: Codable {
        let name: String
    }
    
// MARK: - ViewDidLoad
      override func viewDidLoad() {
        
        super.viewDidLoad()
        gradientBackground()
        self.navigationController!.navigationBar.tintColor = UIColor.white
        iconTeam.image = UIImage(named: "\(id)")
        
        tableView.dataSource = self
        tableView.delegate = self
        getJSON()
        getRoster()
        getLastGame()
        
        
    }
    
    //MARK: - getStats
        func getJSON() {
               let url = URL(string: "https://statsapi.web.nhl.com/api/v1/teams/\(id)?expand=team.stats")!
                 URLSession.shared.dataTask(with: url) { (data, response, err) in
                         if let data = data {
                            DispatchQueue.main.async {
                                let myData = try? JSONDecoder().decode(Welcome.self, from: data)
                                self.teamLabel.text = "\(myData!.teams[0].name) (\(myData!.teams[0].abbreviation))"
                                self.divisionLabel.text = "Division: \(myData!.teams[0].division.name)"
                                self.conferenceLabel.text = "Conference: \(myData!.teams[0].conference.name)"
                                self.venueLabel.text = "Venue: \(myData!.teams[0].venue.name)"
                                self.firstYearLabel.text! += "\(myData!.teams[0].firstYearOfPlay)"
                                
                                self.firstArr.append("Games Played:   \(myData!.teams[0].teamStats[0].splits[0].stat.gamesPlayed ?? 0)")
                                self.firstArr.append("Power play percentage:   " + myData!.teams[0].teamStats[0].splits[0].stat.powerPlayPercentage + " %")
                                self.firstArr.append("Penalty kill percentage:   " + myData!.teams[0].teamStats[0].splits[0].stat.penaltyKillPercentage + " %")
                                self.firstArr.append("Face-off win percentage:   " + myData!.teams[0].teamStats[0].splits[0].stat.faceOffWinPercentage + " %")
                                self.firstArr.append("Shooting percentage:   \(myData!.teams[0].teamStats[0].splits[0].stat.shootingPctg ?? 0.0) %")
                                self.firstArr.append("Save percentage:    \(myData!.teams[0].teamStats[0].splits[0].stat.savePctg ?? 0.0) %")
                                self.firstArr.append("Save percentage rank:   " + (myData!.teams[0].teamStats[0].splits[0].stat.savePctRank ?? "unknown"))
                                self.firstArr.append("Shooting percentage rank:   " + (myData!.teams[0].teamStats[0].splits[0].stat.shootingPctRank ?? "unknown"))
                                self.tableView.reloadData()
                            }
                    }
                 }.resume()
    }

    //MARK: - getRoster
    func getRoster() {
           let url = URL(string: "https://statsapi.web.nhl.com/api/v1/teams/\(id)?expand=team.roster")!
                    URLSession.shared.dataTask(with: url) { (data, response, err) in
                        if let data = data {
                            DispatchQueue.main.async {
                                let myData = try? JSONDecoder().decode(Welcome2.self, from: data)
                                    for i in 0..<myData!.teams[0].roster.roster.count {
                                        self.secondArr.append(myData!.teams[0].roster.roster[i].person.fullName)
                                        self.secondArrJersey.append(myData!.teams[0].roster.roster[i].jerseyNumber)
                                    }
                               }
                        }
            }.resume()
    }
    
    func getLastGame() {
           let url = URL(string: "https://statsapi.web.nhl.com/api/v1/teams/\(id)?expand=team.schedule.previous")!
                     URLSession.shared.dataTask(with: url) { (data, response, err) in
                         if let data = data {
                             DispatchQueue.main.async {
                                let myData = try? JSONDecoder().decode(Welcome3.self, from: data)
                                self.thirdArr.append("\(myData!.teams[0].previousGameSchedule.dates[0].games[0].teams.home.team.name) - \(myData!.teams[0].previousGameSchedule.dates[0].games[0].teams.away.team.name)")
                                self.thirdArr.append("Score:  \(myData!.teams[0].previousGameSchedule.dates[0].games[0].teams.home.score) - \(myData!.teams[0].previousGameSchedule.dates[0].games[0].teams.away.score)")
                               }
                        }
            }.resume()
    }
    
 //MARK: -switch segment
    @IBAction func switchSrgment(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
//MARK: -Interface
    public func gradientBackground() {
        self.navigationController?.isNavigationBarHidden = false
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
        view.layer.addSublayer(layer)
        layer.zPosition = -1
       
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
}

//MARK: -table protocols
extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmControl.selectedSegmentIndex {
            case 0:
                return firstArr.count
            case 1:
                return secondArr.count
            case 2:
                return 1
            default:
                break
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellStat = tableView.dequeueReusableCell(withIdentifier: "cellStatsID", for: indexPath)
          
        switch segmControl.selectedSegmentIndex {
        case 0:
            cellStat.textLabel?.text = firstArr[indexPath.row]
            cellStat.detailTextLabel?.text = ""
        case 1:
            cellStat.textLabel?.text = secondArr[indexPath.row]
            cellStat.detailTextLabel?.text = "Jersey number: \(secondArrJersey[indexPath.row])"
        case 2:
            cellStat.textLabel?.text = thirdArr[0]
            cellStat.detailTextLabel?.text = thirdArr[1]
        default:
            break
       }
        cellStat.backgroundColor = UIColor.clear
        return cellStat
    }
}
