//
//  ViewController.swift
//  IosProject
//
//  Created by  on 03/03/2020.
//  Copyright © 2020 romain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var movieVideoArray : [MovieVideo] = []
    
    @IBOutlet weak var labelTitleMovie: UILabel!
    @IBOutlet weak var labelYearMovie: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelTimeMovie: UILabel!
    @IBOutlet weak var labelSynopsis: UILabel!
    @IBOutlet weak var imageFull: UIImageView!
    @IBOutlet weak var imageMini: UIImageView!
    @IBOutlet weak var stackCategories: UIStackView!
    
    // add link url in the button
    @IBAction func buttonPlay(_ sender: Any) {
        
        var idYoutubeVideo = ""
        
        movieVideoArray.forEach { (movieVideo) in
            idYoutubeVideo = movieVideo.key!
        }
        
        let youtubeUrl = "https://www.youtube.com/watch?v=\(idYoutubeVideo)"
        if let url = URL(string: "\(youtubeUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        // or outside scope use this
        guard let url = URL(string: "\(youtubeUrl)"), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    var idMovie : Int?
    
    // when the view is created and loaded
    override func viewDidLoad() {
        // load parent
        super.viewDidLoad()
        
        if let idMovieReceived = idMovie {
            downloadMovieDetail(idMovie: idMovieReceived)
        }
    }
    
    let urlString = "https://image.tmdb.org/t/p/w342/"
    
    // a callback fonction type with with id movie in parameter
    func downloadMovieDetail(idMovie : Int) {
        let api = Api()
        
        let session = URLSession.shared
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(idMovie)?api_key=\(api.apiKey)&language=fr-FR&append_to_response=videos")!
        
        
        //completionHandler is param of type function, the closure have two param
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                
                // Check if an error occured
                if error != nil {
                    // to manage the error
                    return
                }
                
                // Check the response
                if let nonNilData = data {
                    // Serialize the data into an object
                    let movie : Movie? = try? JSONDecoder().decode(Movie.self, from: nonNilData)
                    if let movie = movie {
                        self.updateDataMovie(movie : movie)
                    }
                }
            }
        })
        task.resume()
    }
    
    func updateDataMovie(movie : Movie) {
        if let time = movie.time {
            let newTime = self.minutesToHoursMinutes(minutes: time)
            self.labelTimeMovie.text = newTime
        }
        
        // to remove fake categories demonstration view
        self.stackCategories.removeAllArrangedSubviews()
        
        let allGenres = movie.genres
        
        // for each genres
        allGenres?.forEach({ (genre) in
            let labelView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
            labelView.text = genre.name
            labelView.backgroundColor = UIColor.init(cgColor: CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1))
            labelView.textColor = UIColor.white
            labelView.textAlignment = NSTextAlignment.center
            
            self.stackCategories.addArrangedSubview(labelView)
        })
        
        if let title = movie.title {
            self.labelTitleMovie.text = title
        }
        
        if let date = movie.date {
            self.labelYearMovie.text = self.dateFormat(theDate: date)
        }
        
        if let subTitle = movie.subTitle {
            self.labelSubTitle.text = subTitle
        }
        
        if let synopsis = movie.synopsis {
            self.labelSynopsis.text = synopsis
        }
        
        
        if let imageFull = movie.image2, let url = URL(string: (self.urlString + (imageFull))) {
            self.imageFull.downloadImage(from: url)
        }
        
        if let imageMini = movie.image, let url = URL(string: (self.urlString + (imageMini))) {
            self.imageMini.downloadImage(from: url)
        }
        
        movie.video?["results"]?.forEach({ (theMovieVideo) in
            // show movie videos details
            // print(movie.video?["results"]!)
            self.movieVideoArray.append(theMovieVideo)
        })
    }
    
    // to return int minutes in hour and minutes
    func minutesToHoursMinutes (minutes : Int) -> String {
        let hour = minutes / 60
        let minutes = minutes % 60
        
        return "\(hour)h\(minutes)"
        
    }
    
    // to return the english date format to french format
    func dateFormat(theDate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: theDate)!
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let newDate = dateFormatter.string(from:date)
        
        return newDate
    }
    
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
