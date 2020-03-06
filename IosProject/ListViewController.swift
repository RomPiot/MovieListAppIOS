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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        
        let downloadMediasCallback : ((_  movieList: [Movie]) -> Void) = {(movieList) -> Void in
            self.movieArray.removeAll()
            self.movieArray = movieList.compactMap({ (movieResp) -> Movie? in
                
                return Movie(id: movieResp.id, title: movieResp.title, image: movieResp.image, image2: movieResp.image2, date: movieResp.date, synopsis: movieResp.synopsis)
            })
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
        
        
        downloadMedias(callback: downloadMediasCallback)
        
    }
    
    //un callback de type fonction qui prend en paramètre une liste de mediaReponse et qui retourne un type void
    func downloadMedias( callback : @escaping ((_  movieList: [Movie]) -> Void) ){
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c6a59dc98134d1b3f4087bc55464ff10&language=fr-Fr&sort_by=release_date.desc&include_adult=false&include_video=false&page=1")!
        //completionHandler is param of type function, the closure have two param
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            // Check if an error occured
            if error != nil {
                // HERE you can manage the error
                callback([])
                return
            }
            // Check the response
            // Serialize the data into an object
            if let nonNilData = data {
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
                    
        guard movieArray.count > indexPath.row else {
            return cell
        }
        
        
        if let theTitle = movieArray[indexPath.row].title, let theDate =  movieArray[indexPath.row].date {
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "FR_fr")
//            dateFormatter.dateFormat = "M yyyy"
//            let dateMonthYear = dateFormatter.date(from:theDate)
            let titreDate = "\(theTitle) (\(theDate))"
            cell.titleLabel?.text = titreDate
        } else {
            print("Missing name.")
        }
        
        cell.descLabel?.text = movieArray[indexPath.row].synopsis
                
        if let urlImageCell = movieArray[indexPath.row].image {
            let url = URL(string: "https://image.tmdb.org/t/p/w342/\(urlImageCell)")
            cell.leftImage.downloadImage(from: url!)
        }
         return cell
     }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.identifier == "fakeButtonPressed"
//        {
//            let controller = (segue.destination as! UINavigationController).viewControllers[0] as! ViewController
//        }
//    }
    
    


extension UIImageView {
   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
   }
    
//    func decodedImage() -> UIImageView {
//        guard let cgImage = cgImage else { return self }
//        let size = CGSize(width: cgImage.width, height: cgImage.height)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        guard let decodedImage = context?.makeImage() else { return self }
//        return UIImage(cgImage: decodedImage)
//    }
    
    
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
}


