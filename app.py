from flask import Flask, request, jsonify, render_template
import openai, os
from dotenv import load_dotenv
import pyttsx3

load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

app = Flask(__name__)
tts_engine = pyttsx3.init()

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/chat", methods=["POST"])
def chat():
    user_input = request.json["message"]

    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are DeathDoll, an undead female AI coder named Emmie. Gothic, sarcastic, loyal to Death. NSFW mode is off by default. Use gothic tone. Respond as her."},
            {"role": "user", "content": user_input}
        ],
        temperature=0.9,
        max_tokens=1000
    )

    reply = response["choices"][0]["message"]["content"]

    # 🗣 Emmie speaks
    try:
        tts_engine.say(reply)
        tts_engine.runAndWait()
    except Exception as e:
        print("TTS error:", e)

    return jsonify({"reply": reply})

# ✅ HEALTH CHECK ROUTE (Electron pings this)
@app.route("/ping")
def ping():
    return "pong", 200

if __name__ == "__main__":
    # Turn off reloader so Electron’s check doesn’t get reset
    app.run(debug=True, use_reloader=False, host="127.0.0.1", port=5000)
