from flask import Flask, request, jsonify
from routing import route_query
from memory_manager import MemoryManager
from blockchain import Blockchain

app = Flask(__name__)

# Initialize Components
memory_manager = MemoryManager()
blockchain = Blockchain()

NODE_ID = "member_labrador"
CATEGORY = "dogs"
NODE_ROLE = "member"

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"node_id": NODE_ID, "role": NODE_ROLE, "status": "online"})

@app.route('/classify', methods=['POST'])
def classify():
    query = request.json
    result = memory_manager.classify_locally(query)
    if not result["resolved"]:
        result = route_query(query)
    return jsonify(result)

@app.route('/reward', methods=['POST'])
def reward_node():
    data = request.json
    blockchain.reward_node(data["node_id"], data["reward"])
    return jsonify({"message": "Reward issued"})
