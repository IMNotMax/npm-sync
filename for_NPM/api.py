import os
import sqlite3
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

DB_PATH = os.getenv("DB_PATH", "/data/database.sqlite")
if not os.path.exists(DB_PATH):
    DB_PATH = os.path.join(os.path.dirname(__file__), "database.sqlite")


def get_hosts():
    try:
        conn = sqlite3.connect(DB_PATH)
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()

        cursor.execute("""
            SELECT
                ph.id,
                je.value AS domain,
                ph.forward_host,
                ph.forward_port
            FROM proxy_host ph,
                 json_each(ph.domain_names) je
            WHERE ph.is_deleted = 0
        """)

        hosts = []
        for row in cursor.fetchall():
            hosts.append(
                {
                    "id": row["id"],
                    "domain": row["domain"],
                    "forward_host": row["forward_host"],
                    "forward_port": row["forward_port"],
                }
            )

        conn.close()
        return hosts
    except Exception as e:
        print(f"Error: {e}")
        return []


@app.route("/api/hosts", methods=["GET"])
def list_hosts():
    hosts = get_hosts()
    return jsonify({"hosts": hosts})


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "db_path": DB_PATH})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5055, debug=True)
