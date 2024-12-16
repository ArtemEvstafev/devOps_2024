from flask import Flask
import psycopg2

app = Flask(__name__)

def get_word_from_db():
    conn = psycopg2.connect(
        dbname="mydatabase",
        user="myuser",
        password="mypassword",
        host="db",
        port="5432"
    )
    cur = conn.cursor()
    cur.execute("SELECT word FROM greetings LIMIT 1;")
    word = cur.fetchone()[0]
    cur.close()
    conn.close()
    return word

@app.route('/')
def hello():
    word = get_word_from_db()
    return f"Hello world from {word}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

