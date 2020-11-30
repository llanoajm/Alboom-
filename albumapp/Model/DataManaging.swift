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
    let dataURL = "https://reqres.in/api/users?page=1"
//    let dataURL = "https://reqres.in/api/users/2"
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
            
            var theData = DataModel(userIds: [1], userEmails: [""], avatarImages: [""], first_names: [""])
            let decodedData = try decoder.decode(UserData.self, from: userData)
            var ids = [1]
            var emails = [""]
            var avatars = [""]
            var first_names = [""]
            var last_names = [""]
            
            for num in 0...decodedData.data.count - 1{
                let id = decodedData.data[num].id
                ids.append(id)
                let email = decodedData.data[num].email
                emails.append(email)
                let avatar = decodedData.data[num].avatar
                avatars.append(avatar)
                let first_name = decodedData.data[num].first_name
                first_names.append(first_name)
                let last_name = decodedData.data[num].last_name
                last_names.append(last_name)
                print (email)
                
                
            }
            let thisData = DataModel(userIds: ids, userEmails: emails, avatarImages: avatars, first_names: first_names)
            theData = thisData
            
            
           
            
            return theData
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
