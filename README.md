
Fake News Detector - Project scaffolding
=======================================
This bundle contains:
- backend/: Flask backend that serves /predict and a training script
- flutter_app/: Minimal Flutter frontend (lib/main.dart)

Quickstart (Backend):
1. Create a virtual env, install deps:
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt

2. Train model and save artifacts (this downloads the dataset and trains an LSTM):
   python train_and_save.py
   -- this creates ./model/tokenizer.joblib and ./model/fake_news_lstm.h5

3. Run the server:
   python app.py
   # or use gunicorn in production

4. For Android emulator, use backend URL http://10.0.2.2:5000/predict
   For real devices, expose backend with ngrok or deploy backend to Render/Railway.

Quickstart (Flutter):
1. Put flutter_app/ into your Flutter project and replace lib/main.dart with the file.
2. Run on Android emulator: flutter run

Notes:
- The training step may take time and requires TensorFlow. Use GPU if available.
- You can skip training if you already have model artifacts from your notebook; place tokenizer.joblib and fake_news_lstm.h5 in backend/model/.
