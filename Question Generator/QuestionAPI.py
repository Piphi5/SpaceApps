from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route('/api')
def return_request():
    return "Hello world"

if __name__ == "__main__":
    app.run()