//
//  MainViewController.swift
//  MyNHL
//
//  Created by Polina on 10/29/19.
//  Copyright © 2019 harinovskaya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var winnersTable: UITableView!
    let idCell = "winner"
    let yearsArr = ["2020 - Unknown","2019 - St. Louis Blues", "2018 - Washington Capitals", "2017 - Pittsburgh Penguins", "2016 - Pittsburgh Penguins", "2015 - Chicago Blackhawks"]
    let winnersArr = ["Who wins Stanley Cup 2020?",
                      "Louis Blues winning their first Stanley Cup in franchise history.",
                      "Washington Capitals winning their first Stanley Cup in franchise history.",
                      "The Penguins won the Stanley Cup for the fifth time.",
                      "Penguins captain Sidney Crosby was awardedas the most valuable player of the playoffs.",
                      "The Western Conference champion Chicago Blackhawks defeated the Eastern Conference champion."]
    let imgArr = [UIImage(named: "2020img"), UIImage(named: "2019img"), UIImage(named: "2018img"), UIImage(named: "2017img"), UIImage(named: "2016img"), UIImage(named: "2015img"),]

    //MARK: -View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
       gradientBackground()
    
        //MARK: table
        winnersTable.dataSource = self
        winnersTable.delegate = self
    }
   
}


//MARK: -Table Protocols extension
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yearsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell = tableView.dequeueReusableCell(withIdentifier: idCell)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: idCell)
        }
        cell!.textLabel?.text = yearsArr[indexPath.row]
        cell!.selectionStyle = .none
        cell!.detailTextLabel?.text = winnersArr[indexPath.row]
        cell!.detailTextLabel?.numberOfLines = 4
        cell!.textLabel?.textColor = UIColor.white
        cell!.detailTextLabel?.textColor = UIColor.white
        cell!.imageView?.image = imgArr[indexPath.row]
        cell!.backgroundColor = UIColor.clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
 
    //MARK: -Interface
    public func gradientBackground() {
        self.navigationController?.isNavigationBarHidden = true
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.gray.cgColor, UIColor.black.cgColor]
        view.layer.addSublayer(layer)
        layer.zPosition = -1
    }
    
}


    

   

 
