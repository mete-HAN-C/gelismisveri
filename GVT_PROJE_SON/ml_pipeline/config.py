SERVER   = r"localhost"
DATABASE = "FintechDB"

CONN_STR = (
    f"Driver={{ODBC Driver 17 for SQL Server}};"
    f"Server={SERVER};"
    f"Database={DATABASE};"
    f"Trusted_Connection=yes;"
)