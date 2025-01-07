# Data Exploration and Loading

import pandas as pd
import psycopg2
from sqlalchemy import create_engine

df = pd.read_csv(r'C:\Users\HP\Documents\DA-1\my_env1\Walmart.csv', encoding_errors="ignore") # if any row has any issues it will ignore

#print(df.head()) # print 1st 5 rows
#print(df.shape)  # tells how many data's are present
#print(df.info()) # gives the info about data

#finding duplicate
#print(df.duplicated().sum()) # sum is to check true duplicates or false duplicates in our case we need true duplicates

#finding missing values 
#print(df.isnull().sum())

# Now that we have 10051 records with duplicates values in order to remove duplicate we'll use
print(df.drop_duplicates(inplace=True))
#print(df.shape)

#final output value after removing duplicate 10000

# Next we have msiing values for col unit price and quantity in order to remove it we'll drop null values
print(df.dropna(inplace = True))

#print(df.shape)
#print(df.info())

#after looking at the data unit price is in $ as well as in object type we need to change to int or float
df['unit_price'] = df['unit_price'].str.replace('$', '', regex=False).astype(float)
print(df['unit_price'])

#now we're gonna add new col called total by multiplying unit price and quantity
df['Total'] = df['unit_price']* df['quantity']
print(df['Total'])
print(df.head())

# To save the data
df.to_csv('walmart_clean_data.csv', index=False)

#Now we're gonna give connection to a sql
#psql
#host = 'localhost'
#port = 5432
#user = "postgres"
#password = 'Kpriyu001'
#dbname = 'walmart_db'

# Create an engine
engine_psql = create_engine("postgresql+psycopg2://postgres:Kpriyu001@localhost:5432/walmart_db")

# Connect to the engine
try:
    engine_psql
    print("Connection successful!")

except Exception as e:
    print(f"Connection failed: {e}")

# Write DataFrame to SQL
try:
    df.to_sql(name='walmart', con=engine_psql, if_exists='replace', index=False)
    print("DataFrame successfully written to the 'walmart' table.")
except Exception as e:
    print("Error writing DataFrame to SQL:", e)
