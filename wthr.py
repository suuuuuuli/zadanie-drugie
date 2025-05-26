from flask import Flask, render_template, request
import requests
import logging
import os

app = Flask(__name__, template_folder="templates")

AUTHOR_NAME = "Jan Kowalski"
TCP_PORT = int(os.environ.get("PORT", 5000))
API_KEY = os.environ.get("WEATHER_API_KEY", "47feabdc1c1a862d7768f64464d2a34c")

locations = {
    "Polska": ["Poznan", "Sopot", "Gdańsk"],
    "Niemcy": ["Stuttgart", "Dortmund", "Hannover"]
}

@app.route("/", methods=["GET", "POST"])
def index():
    weather_data = None
    selected_country = None
    selected_city = None

    if request.method == "POST":
        selected_country = request.form.get("country")
        selected_city = request.form.get("city")
        weather_data = get_weather(selected_city)

    return render_template("index.html",
                           locations=locations,
                           selected_country=selected_country,
                           selected_city=selected_city,
                           weather_data=weather_data)

def get_weather(city):
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric&lang=pl"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        return {
            "temperatura": data["main"]["temp"],
            "opis": data["weather"][0]["description"],
            "wiatr": data["wind"]["speed"]
        }
    else:
        return {"error": "Nie udało się pobrać pogody."}

if __name__ == "__main__":
    logging.info(f"Aplikacja uruchomiona.")
    logging.info(f"Autor: {AUTHOR_NAME}")
    logging.info(f"Nasłuchiwanie na porcie TCP: {TCP_PORT}")
    app.run(host="0.0.0.0", port=TCP_PORT)
