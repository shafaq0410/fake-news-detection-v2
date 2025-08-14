
from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib, os, traceback
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.sequence import pad_sequences
from newspaper import Article
import numpy as np

app = Flask(__name__)
CORS(app)

MODEL_DIR = os.path.join(os.path.dirname(__file__), 'model')

# Load artifacts if present
tokenizer = None
config = None
model = None
try:
    tokenizer = joblib.load(os.path.join(MODEL_DIR, 'tokenizer.joblib'))
    config = joblib.load(os.path.join(MODEL_DIR, 'config.joblib'))
    model = load_model(os.path.join(MODEL_DIR, 'fake_news_lstm.h5'))
    print("Model and tokenizer loaded.")
except Exception as e:
    print("Warning: model/tokenizer not found or failed to load. Run train_and_save.py to create them.\\n", e)

def extract_text_from_url(url):
    art = Article(url)
    art.download()
    art.parse()
    return art.text

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json(force=True)
        text = data.get('text')
        url = data.get('url')
        if not text and url:
            text = extract_text_from_url(url)
        if not text:
            return jsonify({'error': 'No text or url provided'}), 400
        if tokenizer is None or model is None or config is None:
            return jsonify({'error': 'Model not available on server. Please run training script to generate model artifacts.'}), 500
        seq = tokenizer.texts_to_sequences([text])
        X = pad_sequences(seq, maxlen=config.get('max_seq_len', 200), padding='post', truncating='post')
        prob = float(model.predict(X)[0][0])
        pred = 'Fake' if prob >= 0.5 else 'Real'
        return jsonify({'prediction': pred, 'confidence': prob, 'text_snippet': text[:800]})
    except Exception as e:
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
