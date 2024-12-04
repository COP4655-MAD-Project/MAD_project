import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            //Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.96, green: 0.87, blue: 0.68), Color.brown]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            //Main content
            VStack(spacing: 20) {
                Text("Miami's Weather")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Temperature:")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Text(viewModel.temperature)
                            .foregroundColor(.white)
                    }

                    HStack {
                        Text("Wind Speed:")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Text(viewModel.windspeed)
                            .foregroundColor(.white)
                    }

                    HStack {
                        Text("Rainfall Expected:")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Text(viewModel.precipitation)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .padding()

                Spacer()
            }
            .onAppear {
                viewModel.fetchWeather()
            }
            .padding()
        }
    }
}

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var windspeed: String = "--"
    @Published var precipitation: String = "--"

    private let apiURL = "https://api.open-meteo.com/v1/forecast?latitude=25.7617&longitude=-80.1918&current_weather=true"

    func fetchWeather() {
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        let celsiusTemperature = weatherData.current_weather.temperature
                        let fahrenheitTemperature = (celsiusTemperature * 9 / 5) + 32
                        self.temperature = "\(fahrenheitTemperature)°F"

                        let kmphWindSpeed = weatherData.current_weather.windspeed
                        let mphWindSpeed = kmphWindSpeed * 0.621371
                        self.windspeed = String(format: "%.2f mph", mphWindSpeed)

                        if let precipitationMM = weatherData.current_weather.precipitation {
                            let precipitationInches = precipitationMM * 0.0393701
                            self.precipitation = String(format: "%.2f in", precipitationInches)
                        } else {
                            self.precipitation = "0.00 in"
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("HTTP request failed: \(error)")
            }
        }.resume()
    }
}

struct WeatherData: Decodable {
    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
        let precipitation: Double?
    }
    let current_weather: CurrentWeather
}

#Preview {
    WeatherView()
}
