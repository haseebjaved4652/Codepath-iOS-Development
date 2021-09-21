//
//  MovieGridViewController.swift
//  flickster
//
//  Created by HaseebJaved on 9/20/21.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
 
    
    
    @IBOutlet weak var colllectionView: UICollectionView!
    
    var movies = [[String:Any]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colllectionView.delegate = self
        colllectionView.dataSource = self
        
        let layout = colllectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try!
                        JSONSerialization.jsonObject(with: data, options: [])
                        as! [String: Any]

                //hey movies, i want yo to look into that data dictionary and get that result
                self.movies = dataDictionary["results"] as! [[String:Any]]
                //self. is important to fix Reference to property 'movies' in closure `requires explicit use of 'self' to make capture semantics explicit
                
                // reload the data or else the 20 movies that wont show up else
                self.colllectionView.reloadData()
                print(self.movies)
             }
        }
        task.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
