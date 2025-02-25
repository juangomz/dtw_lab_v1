import uvicorn
from fastapi import FastAPI
from fastapi.responses import FileResponse
from pathlib import Path
import toml
from dtw_lab.lab1 import (
    read_csv_from_google_drive,
    visualize_data,
    calculate_statistic,
    clean_data,
)
import pandas as pd
import requests
import io

# Inicializar la instancia de la aplicación FastAPI
app = FastAPI()

# Configuración del servidor para desplegar la aplicación
def run_server(port: int = 80, reload: bool = False, host: str = "127.0.0.1"):
    uvicorn.run("dtw_lab.lab2:app", port=port, reload=reload, host=host)

# Definir una ruta de entrada para la aplicación
@app.get("/")
def main_route():
    return {"message": "Hello world"}


# Read CSV data from Google Drive
def read_csv_from_google_drive(file_id: str) -> pd.DataFrame:
    download_url = f'https://drive.google.com/uc?export=download&id={file_id}'
    try:
        s = requests.get(download_url).content   
        return pd.read_csv(io.StringIO(s.decode('utf-8')))
    except Exception as e:
        raise ValueError(f"Unable to read CSV file from Google Drive: {str(e)}")

# Clean the data
def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    df = df.dropna()
    df = df.drop(columns=['Serial_Number', 'Voltage_Cutoff', 'Nominal_Voltage'])
    df = df[(df['Avg_Operating_Temperature'] <= 100)]
    df = df[(df['Days_Since_Production'] <= 20000)]
    df = df[(df['Current_Voltage'] >= 0.5) & (df['Current_Voltage'] <= 2)]
    df = df[df['Battery_Size'] != '9 - Volt']
    return df

# Route to get the statistic based on measure and column
@app.get("/statistic/{measure}/{column}")
def mock_dependencies(mocker):
    """Mockea las funciones externas usadas en get_statistic."""
    mock_read_csv = mocker.patch("src.dtw_lab.lab2.read_csv_from_google_drive")
    mock_clean_data = mocker.patch("src.dtw_lab.lab2.clean_data")
    mock_calculate_statistic = mocker.patch("src.dtw_lab.lab2.calculate_statistic")

    # Configurar valores de retorno simulados
    mock_read_csv.return_value = {"fake": "data"}  # Simula un DataFrame leído
    mock_clean_data.return_value = {"column": [1, 2, 3, 4, 5]}  # Simula datos limpios
    mock_calculate_statistic.return_value = 3  # Simula el resultado del cálculo estadístico

    return mock_read_csv, mock_clean_data, mock_calculate_statistic


def test_get_statistic(mock_dependencies):
    """Prueba get_statistic con mocks en las funciones dependientes."""
    mock_read_csv, mock_clean_data, mock_calculate_statistic = mock_dependencies

    measure = "mean"
    column = "column"
    result = get_statistic(measure, column)

    # Verificaciones
    assert result == {"measure": measure, "column": column, "statistic": 3}
    assert mock_read_csv.called
    assert mock_clean_data.called
    assert mock_calculate_statistic.called

    mock_read_csv.assert_called_once()
    mock_clean_data.assert_called_once()
    mock_calculate_statistic.assert_called_once_with(measure, {"column": [1, 2, 3, 4, 5]})

def get_statistic(measure: str, column: str):
    # Read the CSV data, clean the data, and calculate the statistic.
    file_id = "1eKiAZKbWTnrcGs3bqdhINo1E4rBBpglo"  # Replace with actual Google Drive file ID
    df = read_csv_from_google_drive(file_id)
    cleaned_data = clean_data(df)
    statistic = calculate_statistic(measure, cleaned_data[column])
    return {"measure": measure, "column": column, "statistic": statistic}

# Route to get the visualization based on graph type
@app.get("/visualize/{graph_type}")
def get_visualization(graph_type: str):
    # Read the CSV data, clean the data, and visualize it.
    file_id = "1eKiAZKbWTnrcGs3bqdhINo1E4rBBpglo"  # Replace with actual Google Drive file ID
    df = read_csv_from_google_drive(file_id)
    cleaned_data = clean_data(df)

    # Generate graph based on graph_type (e.g., 'scatter', 'box', 'histogram')
    if graph_type == "scatter":
        visualize_data(cleaned_data)  # Scatter plot visualization
        image_path = 'graphs/scatter_plots.png'
    elif graph_type == "box":
        visualize_data(cleaned_data)  # Box plot visualization
        image_path = 'graphs/boxplots.png'
    elif graph_type == "histogram":
        visualize_data(cleaned_data)  # Histogram visualization
        image_path = 'graphs/histograms.png'
    else:
        return {"error": "Invalid graph type. Choose 'scatter', 'box', or 'histogram'."}

    return FileResponse(image_path)

# Route to get the version from pyproject.toml
@app.get("/version")
def get_visualization_version():
    import toml
    pyproject = toml.load("pyproject.toml")
    version = pyproject["tool"]["poetry"]["version"]
    return {"version": version}