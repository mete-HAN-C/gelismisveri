import os
import json
import pickle
import warnings
import pandas as pd
import pyodbc
from config import CONN_STR

warnings.filterwarnings('ignore')

MODEL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "model.pkl")
MODEL_NAME = "LogisticRegression_v1"

def load_model():
    with open(MODEL_PATH, 'rb') as f:
        return pickle.load(f)

def fetch_prediction_data():
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
        1 AS HesapSayisi,
        0 AS GecmisBasvuru,
        0 AS GecmisRed
    FROM dbo.Kredi_Basvuru kb;
    """
    with pyodbc.connect(CONN_STR) as conn:
        return pd.read_sql(query, conn)

def predict_and_save():
    print("=" * 60)
    print("ML PIPELINE - TAHMIN VE ETL ASAMASI")
    print("=" * 60)

    if not os.path.exists(MODEL_PATH):
        print(f"   HATA: Model dosyasi bulunamadi. Once train_model.py calistirin.")
        return
    
    pkl = load_model()
    model = pkl['model']
    feature_cols = pkl['feature_cols']

    df = fetch_prediction_data()
    X = df[feature_cols]
    
    proba = model.predict_proba(X)[:, 1]
    df['Cikti']         = proba
    df['TahminAdi']     = ['ONAY' if p >= 0.5 else 'RED' for p in proba]

    print("\n[ETL] Sonuclar ML_Model_Sonuc tablosuna yaziliyor...")
    insert_count = 0
    
    with pyodbc.connect(CONN_STR) as conn:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM dbo.ML_Model_Sonuc WHERE ModelAdi = ?", MODEL_NAME)
        
        for _, row in df.iterrows():
            cursor.execute("""
                INSERT INTO dbo.ML_Model_Sonuc 
                (MusteriID, BasvuruID, ModelAdi, Cikti, TahminEtiketi, Tarih)
                VALUES (?, ?, ?, ?, ?, GETDATE())
            """,
                int(row['MusteriID']),
                int(row['BasvuruID']),
                MODEL_NAME,
                float(row['Cikti']),
                row['TahminAdi']
            )
            insert_count += 1
        conn.commit()
    
    print(f"   {insert_count} yeni tahmin basariyla yazildi.")

    print("\n[RAPOR] T-SQL vs Python ML Karsilastirmasi (Top 5):")
    karsilastirma_query = """
    SELECT TOP 5
        m.MusteriID,
        m.Ad + ' ' + m.Soyad AS Musteri,
        ml.Cikti              AS ML_Olasilik,
        ml.TahminEtiketi      AS ML_Tahmin,
        ks.Skor               AS TSQL_Skor
    FROM dbo.Musteri m
    INNER JOIN dbo.ML_Model_Sonuc ml ON m.MusteriID = ml.MusteriID
    LEFT JOIN (
        SELECT MusteriID, AVG(Skor) AS Skor
        FROM dbo.Kredi_Skoru
        WHERE HesaplamaYontemi = 'SADE_LINEER'
        GROUP BY MusteriID
    ) ks ON m.MusteriID = ks.MusteriID
    WHERE ml.ModelAdi = ?
    ORDER BY ml.Cikti DESC;
    """
    with pyodbc.connect(CONN_STR) as conn:
        comparison = pd.read_sql(karsilastirma_query, conn, params=[MODEL_NAME])
    print(comparison.to_string(index=False))
    print("=" * 60)

if __name__ == "__main__":
    predict_and_save()