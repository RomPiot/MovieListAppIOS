//
//  ListViewController.swift
//  IosProject
//
//  Created by  on 04/03/2020.
//  Copyright © 2020 romain. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId : String = "cellId"
    
    var movieArray : [Movie] = []
    var imageCache : [String:UIImage] = [:]
    
    // when the view is created and loaded
    override func viewDidLoad() {
        
        // load parent
        super.viewDidLoad()
        
        // transfert behavhior to delegate class
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        let downloadMediasCallback : ((_  movieList: [Movie]) -> Void) = {(movieList) -> Void in
            self.movieArray.removeAll()
            self.movieArray = movieList.compactMap({ (movieResp) -> Movie? in
                
                return Movie(id: movieResp.id, title: movieResp.title, image: movieResp.image, image2: movieResp.image2, date: movieResp.date, synopsis: movieResp.synopsis, time: movieResp.time, subTitle: movieResp.subTitle, genres: movieResp.genres, video: movieResp.video)
            })
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
        downloadMedias(callback: downloadMediasCallback)
    }
    
    // a callback fonction type with with list movie in parameter
    func downloadMedias( callback : @escaping ((_  movieList: [Movie]) -> Void) ){
        let api = Api()
        let session = URLSession.shared
        let urlMovieList = URL(string: api.movieList)
        
        guard let url = urlMovieList else {
            return
        }
        
        //completionHandler is param of type function, the closure have two param
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            // Check if an error occured
            if error != nil {
                // to manage the error
                callback([])
                return
            }
            
            // Check the response
            if let nonNilData = data {
                // Serialize the data into an object
                let movies : MovieResponse? = try? JSONDecoder().decode(MovieResponse.self, from: nonNilData)
                
                callback(movies?.movieList ?? [])
                return
            }
            callback([])
        })
        task.resume()
    }
    
    // To return the number of movies found
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieTableViewCell
        
        // if index isn't in movieArray
        guard movieArray.count > indexPath.row else {
            return cell
        }
        
        // if isset title and date of this movie
        if let theTitle = movieArray[indexPath.row].title, let theDate =  movieArray[indexPath.row].date {
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr_FR")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: theDate)!
            dateFormatter.dateFormat = "MMMM yyyy"
            let newDate = dateFormatter.string(from:date)
            
            
            let titreDate = "\(theTitle) (\(newDate))"
            cell.titleLabel?.text = titreDate
        } else {
            print("Missing name or date.")
            return cell
        }
        
        cell.descLabel?.text = movieArray[indexPath.row].synopsis
        
        if let urlImageCell = movieArray[indexPath.row].image {
            let stringPath = "https://image.tmdb.org/t/p/w342/"
            // imageCache = [stringPath : UIImage(imageLiteralResourceName: urlImageCell)]
            let urlImageCell = URL(string: stringPath + urlImageCell)
            
            // or outside scope use this
            guard let url = urlImageCell else {
                return cell
            }
            
            cell.leftImage.downloadImage(from: url)
        }
        return cell
    }
    
    var selectedMovie = Movie?.self
    
    // when the cell is selected in list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idRow = movieArray[indexPath.row].id
        performSegue(withIdentifier: "navigateToDetailView", sender: idRow)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToDetailView" {
            let viewController = segue.destination as! ViewController
            
            // set a variable in the viewController with the data to pass
            viewController.idMovie = sender as? Int
        }
    }
}

// to add function in UIImageView
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
    
    func getImageCache(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}


