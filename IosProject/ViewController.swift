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
    @IBOutlet weak var imageFull: UIImageView!
    @IBOutlet weak var imageMini: UIImageView!

    @IBAction func buttonPlay(_ sender: Any) {
    }
    var idMovie : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let idMovieReceived = idMovie {
            downloadMovieDetail(idMovie: idMovieReceived)
        }
  }
    
    let apiKey : String = "c6a59dc98134d1b3f4087bc55464ff10"
    let urlString = "https://image.tmdb.org/t/p/original/"
    
    // a callback fonction type with with id movie in parameter
    func downloadMovieDetail(idMovie : Int) {
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(idMovie)?api_key=\(apiKey)&language=fr-FR")!
        //completionHandler is param of type function, the closure have two param
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
            // Check if an error occured
            if error != nil {
                // to manage the error
                return
            }
            // Check the response
            // Serialize the data into an object
            if let nonNilData = data {
                let movie : Movie? = try? JSONDecoder().decode(Movie.self, from: nonNilData)
                
                if let time = movie?.time {
                    let newTime = self.minutesToHoursMinutes(minutes: time)
                    self.labelTimeMovie.text = newTime
                }
                
                self.labelTitleMovie.text = movie?.title
                self.labelYearMovie.text = movie?.date
                
//              self.labelDirectorMovie.text = movie?.
                self.labelSynopsis.text = movie?.synopsis
                
                if let imageFull = movie?.image2, let url = URL(string: (self.urlString + (imageFull))) {
                        self.imageFull.downloadImage(from: url)
                }
                
//                self.imageMini.downloadImage(from: URL(string: ("https://image.tmdb.org/t/p/w342/" + (movie?.image)!))!)
                }
            }
        })
        task.resume()
    }
    
    func minutesToHoursMinutes (minutes : Int) -> String {
        let hour = minutes / 60
        let minutes = minutes % 60
        
        return "\(hour)h\(minutes)"
        
    }
    
}

