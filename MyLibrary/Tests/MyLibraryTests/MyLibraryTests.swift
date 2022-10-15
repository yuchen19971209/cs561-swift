import XCTest
@testable import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(8)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() async throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(0)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNil(isLuckyNumber)
    }

    //Unit test and test Weather
    func testWeatherModel() async {
        //Json hard code
        let jsonContent = """
        {
            "coord": {
            "lon": -123.262,
            "lat": 44.5646
            },
            "weather": [
            {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
            }
            ],
            "base": "stations",
            "main": {
            "temp": 81.81,
            "feels_like": 80.78,
            "temp_min": 77.68,
            "temp_max": 84.94,
            "pressure": 1012,
            "humidity": 35
            },
            "visibility": 10000,
            "wind": {
            "speed": 8.05,
            "deg": 60
            },
            "clouds": {
            "all": 0
            },
            "dt": 1665789800,
            "sys": {
            "type": 2,
            "id": 2040223,
            "country": "US",
            "sunrise": 1665757615,
            "sunset": 1665797445
            },
            "timezone": -25200,
            "id": 5720727,
            "name": "Corvallis",
            "cod": 200
        }
        """
        /********Reference: https://www.twilio.com/blog/working-with-json-in-swift*******/

        // Convert the jsonString to .utf8 encoded data.
        let jsonData = jsonContent.data(using: .utf8)!

        // Create a JSON Decoder object.
        let decoder = JSONDecoder()

        // Decode the JSON data using the APOD struct we created that follows this data's structure.
        let myData = try! decoder.decode(Weather.self, from: jsonData)
        print(myData.main.temp)
        
        //XCTAssertNotNil(testData) and check whether it is same as the hard code
        XCTAssert(myData.main.temp == 81.81)
    }

    //Integration Test
    func testWeatherModelIntegration() async {
        let weatherService = WeatherServiceImpl()
        var temperature = 0
        do {
            temperature = try await weatherService.getTemperature()
            print(temperature)
        } catch {}
        XCTAssertNotNil(temperature)
    }

}
