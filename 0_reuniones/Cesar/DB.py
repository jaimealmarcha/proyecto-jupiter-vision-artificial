import pickle
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine

USR = "-"
PSW = "-"
Instancia = "127.0.0.1:3306/vision_artificial"

engine = create_engine(
    "mysql+mysqlconnector://"+USR+":"+PSW+"@"+Instancia
)

RUTA_DATOS = Path(__file__).parent / "datos" / "tablas.pkl"
RUTA_DATOS_LIMPIAS = Path(__file__).parent / "datos" / "tablas_limpias.pkl"


def obtener_tablas():
    if RUTA_DATOS.exists():
        return list(cargar_datos().keys())

    query = "SHOW TABLES;"
    df = pd.read_sql(query, engine)
    return df.iloc[:, 0].tolist()


def refrescar_datos(ruta=RUTA_DATOS):
    """Conecta a la BD, exporta todas las tablas a fichero y devuelve el diccionario."""
    tablas = pd.read_sql("SHOW TABLES;", engine).iloc[:, 0].tolist()
    datos = {tabla: pd.read_sql(f"SELECT * FROM {tabla}", engine) for tabla in tablas}

    ruta = Path(ruta)
    ruta.parent.mkdir(parents=True, exist_ok=True)
    with open(ruta, "wb") as f:
        pickle.dump(datos, f)

    print(f"{len(datos)} tablas exportadas a: {ruta}")
    return datos


def cargar_datos(ruta=RUTA_DATOS):
    """Carga las tablas previamente exportadas desde el fichero pickle."""
    with open(ruta, "rb") as f:
        return pickle.load(f)


def cargar_df(tabla, ruta=RUTA_DATOS):
    return cargar_datos(ruta)[tabla]


if __name__ == "__main__":
    refrescar_datos()
