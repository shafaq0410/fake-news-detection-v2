
import os
import numpy as np
import pandas as pd
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Embedding, LSTM, Dropout
from tensorflow.keras.callbacks import ModelCheckpoint
from sklearn.model_selection import train_test_split
import joblib

# Parameters (tweak if needed)
MAX_NUM_WORDS = 20000
MAX_SEQ_LEN = 200
EMBED_DIM = 100
BATCH_SIZE = 64
EPOCHS = 6

def load_data():
    fake = pd.read_csv('https://raw.githubusercontent.com/laxmimerit/fake-real-news-dataset/main/data/Fake.csv')
    real = pd.read_csv('https://raw.githubusercontent.com/laxmimerit/fake-real-news-dataset/main/data/True.csv')
    fake['label'] = 1
    real['label'] = 0
    df = pd.concat([fake, real], ignore_index=True)
    # use 'title' + 'text' if available
    df['content'] = df['title'].fillna('') + ' ' + df['text'].fillna('')
    df = df[['content', 'label']].dropna().reset_index(drop=True)
    return df['content'].values, df['label'].values

def build_model(vocab_size):
    model = Sequential()
    model.add(Embedding(vocab_size, EMBED_DIM, input_length=MAX_SEQ_LEN))
    model.add(LSTM(128, return_sequences=False))
    model.add(Dropout(0.3))
    model.add(Dense(1, activation='sigmoid'))
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
    return model

def main():
    print("Loading data...")
    texts, labels = load_data()
    print("Tokenizing...")
    tokenizer = Tokenizer(num_words=MAX_NUM_WORDS, oov_token='<OOV>')
    tokenizer.fit_on_texts(texts)
    sequences = tokenizer.texts_to_sequences(texts)
    X = pad_sequences(sequences, maxlen=MAX_SEQ_LEN, padding='post', truncating='post')
    y = np.array(labels)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    print("Building model...")
    model = build_model(min(MAX_NUM_WORDS, len(tokenizer.word_index)+1))
    checkpoint_path = "model_checkpoint.h5"
    checkpoint = ModelCheckpoint(checkpoint_path, monitor='val_accuracy', verbose=1, save_best_only=True, mode='max')

    print("Training... This may take time depending on your machine.")
    model.fit(X_train, y_train, validation_split=0.2, epochs=EPOCHS, batch_size=BATCH_SIZE, callbacks=[checkpoint])

    # Load best and save
    try:
        model.load_weights(checkpoint_path)
    except Exception as e:
        print("Warning: failed to load checkpoint:", e)
    os.makedirs('model', exist_ok=True)
    model.save('model/fake_news_lstm.h5')

    # save tokenizer and config
    joblib.dump(tokenizer, 'model/tokenizer.joblib')
    config = {'max_seq_len': 200, 'max_num_words': 20000}
    joblib.dump(config, 'model/config.joblib')
    print("Saved model and tokenizer to ./model/")

if __name__ == '__main__':
    main()
