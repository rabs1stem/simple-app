from flask import Flask, request, jsonify

app = Flask(__name__)

users = []


@app.route("/")
def home():
    return jsonify({"message": "Hello, World!"}), 200


@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200


@app.route("/api/users", methods=["GET"])
def get_users():
    return jsonify({"users": users}), 200


@app.route("/api/users", methods=["POST"])
def create_user():
    data = request.get_json()

    if not data or "name" not in data:
        return jsonify({"error": "name is required"}), 400

    user = {
        "id": len(users) + 1,
        "name": data["name"]
    }

    users.append(user)

    return jsonify(user), 201


@app.route("/api/users/<int:user_id>", methods=["GET"])
def get_user(user_id):
    for user in users:
        if user["id"] == user_id:
            return jsonify(user), 200

    return jsonify({"error": "user not found"}), 404


@app.route("/api/users/<int:user_id>", methods=["DELETE"])
def delete_user(user_id):
    global users

    for user in users:
        if user["id"] == user_id:
            users = [u for u in users if u["id"] != user_id]
            return jsonify({"message": "deleted"}), 200

    return jsonify({"error": "user not found"}), 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)