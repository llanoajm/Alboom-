//
//  File.swift
//  albumapp
//
//  Created by Antonio Llano on 26/11/20.
//

import Foundation
protocol DataManagingDelegate{
    func didUpdateData(_ dataManaging: DataManaging, data: DataModel)
    func didFailWithError(error: Error)
}

//1. Create a URL
//2. Create a URLSession
//3. Give the session a task
//4. Start the task


struct DataManaging{
//    let dataURL = "https://reqres.in/api/users?page=1"
    let dataURL = "https://reqres.in/api/users/2"
    var delegate: DataManagingDelegate?
    
    func fetchData(){
        
        let urlString = dataURL//"\(dataURL)&page=\(page)"
        
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String){
        
        //fetches data and URL To create a URLSession, assign a task to the session and carry out the task.
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let data =  self.parseJSON(safeData){
                        
                        self.delegate?.didUpdateData(self, data: data)
                        
                    }
                }
                
            }
             task.resume()
        }
        
    }
    func parseJSON(_ userData: Foundation.Data) -> DataModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(UserData.self, from: userData)
            let id = decodedData.data.id
            let email = decodedData.data.email
            let avatar = decodedData.data.avatar
            let first_name = decodedData.data.first_name
            let last_name = decodedData.data.last_name
            
            print(email)
            
            let theData = DataModel(userId: id, userEmail: email, avatarImage: avatar, name: first_name + " " + last_name)
            
            return theData
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
