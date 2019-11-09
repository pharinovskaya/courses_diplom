//
//  SettingsViewController.swift
//  MyNHL
//
//  Created by Polina on 10/29/19.
//  Copyright © 2019 harinovskaya. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, saveFaveDelegate {
    
    func saveFav(changedTeam: String, changedID: Int) {
        favTeamLabel.text = changedTeam
        icon.image = UIImage(named: "\(changedID)")
    }
    
    
    @IBOutlet weak var favTeamLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
 //MARK: -view did load
    override func viewDidLoad() {
           super.viewDidLoad()
           gradientBackground()
        
            favTeamLabel.text = "None "
        
       }
    
//MARK: -share (UIActivityController)
    @IBAction func shareButton(_ sender: UIButton) {
        let sharedText = "Hi! My favorite NHL team is \(favTeamLabel.text!)"
        let ac = UIActivityViewController(activityItems: [sharedText], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
      
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
    
//MARK: -prepare for segue
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SetViewController {
            destVC.delegate = self
        }
    }
}




