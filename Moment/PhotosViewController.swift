//
//  ViewController.swift
//  Moment
//
//  Created by Philippe Kimura-Thollander on 2/2/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var pictures: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.pictures = (responseDictionary["data"] as! [NSDictionary])
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let pictures = pictures {
            return pictures.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell;
        
        let picture = pictures![indexPath.row]
        let imageUrl = NSURL( string: picture.valueForKeyPath("images.standard_resolution.url") as! String)
        print(imageUrl)
        cell.pictureView.setImageWithURL(imageUrl!)
        
        return cell;
    }
    

}

