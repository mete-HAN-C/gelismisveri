import os
import pickle
import warnings
import numpy as np
import pandas as pd
import pyodbc
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.model_selection import train_test_split
from config import CONN_STR

warnings.filterwarnings('ignore')

MODEL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "model.pkl")
SEED = 42
FEATURE_COLS = ['TalepEdilenTutar', 'Vade', 'AylikGelir', 'OrtalamaBakiye']

def fetch_training_data():
    query = """
    SELECT 
        kb.BasvuruID,
        kb.MusteriID,
        kb.TalepEdilenTutar,
        kb.Vade,
        kb.AylikGelir,
        ISNULL((SELECT SUM(
            CASE 
                WHEN ParaBirimi = 'USD' THEN Bakiye * 32.0
                WHEN ParaBirimi = 'EUR' THEN Bakiye * 35.0
                ELSE Bakiye
            END
        ) FROM dbo.Hesap WHERE MusteriID = kb.MusteriID), 0) AS OrtalamaBakiye,
        CASE WHEN kb.Durum = 'ONAYLANDI' THEN 1 ELSE 0 END AS Etiket
    FROM dbo.Kredi_Basvuru kb
    WHERE kb.Durum IN ('ONAYLANDI', 'REDDEDILDI');
    """
    with pyodbc.connect(CONN_STR) as conn:
        return pd.read_sql(query, conn)

def train():
    print("=" * 60)
    print("ML PIPELINE - EGITIM ASAMASI")
    print("=" * 60)

    df = fetch_training_data()
    print(f"   {len(df)} etiketli basvuru bulundu")
    
    if len(df) < 5:
        print(f"   UYARI: Yetersiz veri. Daha fazla veri yukleyin.")
        return None
    
    X = df[FEATURE_COLS]
    y = df['Etiket']
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=SEED)
    
    model = LogisticRegression(max_iter=1000, random_state=SEED)
    model.fit(X_train, y_train)
    print("   Model basariyla egitildi.")
    
    y_pred = model.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    print(f"   Test dogrulugu: {acc*100:.1f}%")
    
    with open(MODEL_PATH, 'wb') as f:
        pickle.dump({
            'model':        model,
            'feature_cols': FEATURE_COLS,
            'accuracy':     acc,
            'n_train':      len(X_train),
            'n_test':       len(X_test)
        }, f)
    print(f"   {MODEL_PATH} kaydedildi.")
    print("=" * 60)

if __name__ == "__main__":
    train()
