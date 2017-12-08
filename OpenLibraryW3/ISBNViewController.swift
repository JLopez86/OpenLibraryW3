//
//  ISBNViewController.swift
//  OpenLibraryW3
//
//  Created by Jose Lopez on 8/12/17.
//  Copyright © 2017 Jose Lopez. All rights reserved.
//

import Foundation
import UIKit

class ISBNViewController: UIViewController {
    
    var titulo : String = ""
    var portada : String = ""
    var autor : String = "- "
    var progreso : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var portadaLibro: UIImageView!
    
    @IBOutlet weak var ISBNTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func leeISBN() {
        
        
        //        var autor : String
        let isbn : String =  (ISBNTextField.text)!
        let urls : String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        
        let url = URL(string : urls)
        
        do {
            let datos = try Data(contentsOf: url! as URL )
            print(datos)
            
            
            
            let json = try JSONSerialization.jsonObject(with: datos, options: .mutableLeaves)
            
            
            let dico1 = json as! NSDictionary
            
            let dico2 = dico1["ISBN:\(isbn)"] as! NSDictionary
            titulo = dico2["title"] as! NSString as String
            let dico3 = dico2["authors"] as! NSArray
            
            for i in dico3 {
                let autorDictionario = i as! NSDictionary
                print(autorDictionario["name"] as! NSString as String)
                
                self.autor += (autorDictionario["name"] as! NSString as String)
                
                
            }
            
            if dico2["cover"] != nil {
                let dico4 = dico2["cover"] as! NSDictionary
                
                self.portada = dico4["large"] as! NSString as String
                print(self.portada)
                mostrarImagen(portada, inView: portadaLibro)
            } else {
                print("sin imagen")
                pararProgreso()
            }
            
            
            
            
            
            titleLabel.text = titulo
            authorLabel.text = autor
            
            //            print(autor)
            titulo = ""
            autor = "- "
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func mostrarImagen(_ uri : String, inView: UIImageView){
        
        let url = URL(string: uri)
        
        let task = URLSession.shared.dataTask(with: url!) {responseData,response,error in
            if error == nil{
                if let data = responseData {
                    
                    DispatchQueue.main.async {
                        inView.image = UIImage(data: data)
                    }
                    
                }else {
                    print("no data")
                }
            }else{
                print(error!)
            }
        }
        
        task.resume()
        pararProgreso()
        
    }
    
    func inicioProgreso() {
        self.progreso.center = self.view.center
        self.progreso.hidesWhenStopped = true
        self.progreso.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(progreso)
        
        self.progreso.startAnimating()
    }
    
    func pararProgreso() {
        self.progreso.stopAnimating()
    }

    @IBAction func isbnEnter(_ sender: UITextField) {
        inicioProgreso()
        leeISBN()
        
    }
    
}
