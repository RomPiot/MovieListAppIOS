//
//  ViewController.swift
//  IosProject
//
//  Created by  on 03/03/2020.
//  Copyright © 2020 romain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var labelTitleMovie: UILabel!
    @IBOutlet weak var labelYearMovie: UILabel!
    @IBOutlet weak var labelDirectorMovie: UILabel!
    @IBOutlet weak var labelTimeMovie: UILabel!
    @IBOutlet weak var labelSynopsis: UILabel!
    
    @IBAction func buttonPlay(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitleMovie.text = "LE CAS RICHARD JEWELL"
        labelYearMovie.text = "19 février 2020 "
        labelTimeMovie.text = "1h32"
        labelDirectorMovie.text = "Clint Eastwood"
        labelSynopsis.text = "En 1996, Richard Jewell fait partie de l'équipe chargée de la sécurité des Jeux d'Atlanta. Il est l'un des premiers à alerter de la présence d'une bombe et à sauver des vies. Mais il se retrouve bientôt suspecté... de terrorisme, passant du statut de héros à celui d'homme le plus détesté des Etats-Unis. Il fut innocenté trois mois plus tard par le FBI mais sa réputation ne fut jamais complètement rétablie, sa santé étant endommagée par l'expérience."
        
    }


    
}

