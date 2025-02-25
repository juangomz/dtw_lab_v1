from src.dtw_lab.lab2 import get_statistic, calculate_statistic
from src.dtw_lab.lab1 import encode_categorical_vars

import pandas as pd
import pytest
def test_calculate_statistic () :
    df = pd.DataFrame({"Charge_Left_Percentage": [39, 60, 30, 30, 41]})
    assert calculate_statistic("mean", df["Charge_Left_Percentage"]) == 40
    assert calculate_statistic("median", df["Charge_Left_Percentage"]) == 39
    assert calculate_statistic("mode", df["Charge_Left_Percentage"]) == 30

def test_encode_categorical_vars_mapping():
    df = pd.DataFrame({
        'Manufacturer': ['Duracell', 'Energizer'],
        'Battery_Size': ['D', 'AAA'],
        'Discharge_Speed': ['Fast', 'Slow']
    })

    encoded_df = encode_categorical_vars(df)

    assert encoded_df['Battery_Size'].tolist() == [4, 1] 
    assert encoded_df['Discharge_Speed'].tolist() == [3, 1]  


