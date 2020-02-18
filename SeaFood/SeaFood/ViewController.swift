//
//  ViewController.swift
//  SeaFood
//
//  Created by Soni Suman on 18/02/20.
//  Copyright © 2020 Soni Suman. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var objectImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.isEditing = false
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detectImage(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreML model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model filed to process request")
            }
            print(results)
            if let firstResult = results.first {
                    self.navigationItem.title = firstResult.identifier + "!!!"
            }
        }
            
        
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            } catch  {
                print(error.localizedDescription)
            }
        }
}
        
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            return
        }
        objectImageView.image = pickedImage
        guard let pickedCIImage = CIImage(image: pickedImage) else {
            fatalError("could not convert UIImage to CIImage")
        }
        detectImage(image: pickedCIImage)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

