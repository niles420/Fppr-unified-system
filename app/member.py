from flask import Flask, jsonify
import prometheus_client
from prometheus_client import Counter, generate_latest

app = Flask(__name__)

# ✅ Fix: Ensure /health endpoint is properly defined
@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "message": "FPPR Member is running"}), 200

# ✅ Fix: Ensure /metrics endpoint for Prometheus
request_counter = Counter('http_requests_total', 'Total HTTP Re
