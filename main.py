import pandas as pd
import psycopg2
from sqlalchemy import create_engine

# Data loading
df = pd.read_csv(r'C:\Users\HP\Documents\DA-1\my_env1\Walmart.csv', encoding_errors="ignore")

# Data Exploration (commented out for now)
#print(df.head())  # print first 5 rows
#print(df.shape)  # tells how many records are in the dataset
#print(df.info()) # gives info about the dataset

# Finding duplicate rows
#print(df.duplicated().sum()) # count of true duplicates

# Finding missing values
#print(df.isnull().sum()) # count of missing values in each column

# Remove duplicate rows
#print(df.drop_duplicates(inplace=True))
#print(df.shape)

# Remove rows with missing values
#print(df.dropna(inplace=True))
#print(df.shape)
#print(df.info())

# Remove dollar sign and convert unit_price to float
#df['unit_price'] = df['unit_price'].str.replace('$', '', regex=False).astype(float)
#print(df['unit_price'])

# Add a new column "Total" by multiplying unit price and quantity
#df['Total'] = df['unit_price'] * df['quantity']
#print(df['Total'])
#print(df.head())

# Save the cleaned data to a new CSV file
df.to_csv('walmart_clean_data.csv', index=False)

# Connect to PostgreSQL database
host = 'localhost'
port = 5432
user = 'postgres'
password = 'Priyuu#18'
dbname = 'walmart_db'

# Create an engine
engine_psql = create_engine("postgresql+psycopg2://postgres:Priyuu#18@localhost:5432/walmart_db")


# Try to connect to the database
try:
    # Test connection
    engine_psql.connect()
    print("Connection Succeeded to PSQL")
except Exception as e:
    print("Unable to connect:", e)

# Write DataFrame to SQL
try:
    df.to_sql(name='walmart', con=engine_psql, if_exists='replace', index=False)
    print("DataFrame successfully written to the 'walmart' table.")
except Exception as e:
    print("Error writing DataFrame to SQL:", e)