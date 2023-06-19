//
//  UserVM.swift
//  MVVMArchitectureWithAPI
//
//  Created by satheesh kumar on 10/06/23.
//

import Foundation
class UserVm: ObservableObject{
    @Published  var userData = [UserModel]()
    @Published var isApiFailed = false
    @Published var error : UserError?
    @Published private(set) var isRefresh = false
    private var canc = Set<AnyCancellable>()
    func fetchUser(){
        isApiFailed = false
        isRefresh = true
        if let url = URL(string: "https://jsonplaceholder.typicode.com/usersr"){
            URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
               // asyncAfter(deadline: .now() + 1.5 if api is fast Add some timer to check
                DispatchQueue.main.async {
                    if let error = error{
                        self?.isApiFailed = true
                        self?.error = UserError.custom(error: error)
                    }else{
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        if let data = data,let user =  try? jsonDecoder.decode([UserModel].self, from: data){
                            self?.userData = user
                        }else{
                            self?.isApiFailed = true
                            self?.error = UserError.failedDecoder
                        }
                    }
                    self?.isRefresh = false
                }
               
            }.resume()
        }
    }

        func fetchUsers()   {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        guard let url = URL(string: urlString)  else {
          print("url not correcct")
            return
        }
        
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .sink {[weak self] res in
                switch res {
                case .failure(let error):
                    self?.error = userError.custom(error: error)
                default: break
                }
            } receiveValue: { [weak self] users in
                print("users",users)
                self?.user = users
            }.store(in: &canc)
    }
}
}
extension UserVm{
    enum UserError: LocalizedError {
        case custom(error: Error)
        case  failedDecoder
        var errorDescription: String?{
            switch self{
            case .custom(error: let error):
                return error.localizedDescription
            case .failedDecoder:
                return "failed to decode"
            }
        }
    }
}
