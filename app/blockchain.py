import hashlib
import time

class Blockchain:
    def __init__(self):
        self.chain = [self.create_genesis_block()]

    def create_genesis_block(self):
        return {"index": 0, "timestamp": str(time.time()), "data": "Genesis Block", "previous_hash": "0"}

    def add_block(self, data):
        latest_block = self.chain[-1]
        block = {
            "index": len(self.chain),
            "timestamp": str(time.time()),
            "data": data,
            "previous_hash": self.hash_block(latest_block)
        }
        self.chain.append(block)

    def hash_block(self, block):
        encoded_block = str(block).encode()
        return hashlib.sha256(encoded_block).hexdigest()

    def reward_node(self, node_id, reward_amount):
        self.add_block({"node_id": node_id, "reward": reward_amount})
