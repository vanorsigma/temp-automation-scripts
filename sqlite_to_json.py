# chatgpt'd to existence because god knows i cannot be bothered
import sqlite3
import json

def fetch_all_data(db_path):
    # Connect to the SQLite database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Get all table names
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()

    db_data = {}
    for table_name in tables:
        table_name = table_name[0]
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()

        # Get column names
        cursor.execute(f"PRAGMA table_info({table_name})")
        columns = [column[1] for column in cursor.fetchall()]

        # Convert rows to dictionaries
        table_data = [dict(zip(columns, row)) for row in rows]
        db_data[table_name] = table_data

    # Close the connection
    conn.close()

    return db_data

def dump_to_json(db_path, json_path):
    db_data = fetch_all_data(db_path)
    with open(json_path, 'w') as json_file:
        json.dump(db_data, json_file, indent=4)

if __name__ == "__main__":
    db_path = 'input.db'
    json_path = 'output.json'
    dump_to_json(db_path, json_path)
    print(f"Database dumped to {json_path}")
