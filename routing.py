import requests

def route_query(query):
    if query["confidence"] < 0.7:
        leader_response = query_leader(query)
        if leader_response["resolved"]:
            return leader_response

    hive_response = query_hive(query)
    return hive_response

def query_leader(query):
    response = requests.post("http://leader-dogs:5000/classify", json=query)
    return response.json()

def query_hive(query):
    response = requests.post("http://hive:5000/classify", json=query)
    return response.json()
