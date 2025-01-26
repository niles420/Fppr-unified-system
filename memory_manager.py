class MemoryManager:
    def __init__(self):
        self.short_term = {}
        self.mid_term = {}
        self.long_term = Blockchain()

    def classify_locally(self, query):
        if query["category"] in self.short_term:
            return {"resolved": True, "label": self.short_term[query["category"]]}
        return {"resolved": False}

    def add_to_memory(self, key, value, layer="short_term"):
        if layer == "short_term":
            self.short_term[key] = value
        elif layer == "mid_term":
            self.mid_term[key] = value
        elif layer == "long_term":
            self.long_term.add_block({"key": key, "value": value})
