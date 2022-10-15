import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}
enum BaseUrl:String{
    case openweathermap = "https://api.openweathermap.org"
    case mockServer = "https://raw.githubusercontent.com/yuchen19971209/StaticWeb/main/data/2.5/weather.json?"
}
let apiKey = "7994280b9a2ba36353c3aa02f649d537"

class WeatherServiceImpl: WeatherService {
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=\(apiKey)"
    let url = "\(BaseUrl.openweathermap.rawValue)/data/2.5/weather?q=corvallis&units=imperial&appid=\(apiKey)"
    //let url = "\(BaseUrl.mockServer.rawValue)"

    func getTemperature() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                switch response.result {
                case let .success(weather):
                    let temperature = weather.main.temp
                    let temperatureAsInteger = Int(temperature)
                    continuation.resume(with: .success(temperatureAsInteger))

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}

struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
