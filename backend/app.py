from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import os

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    CORS(app)

    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:password@db:5432/inventory_db"
    )
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)

    # Import models
    from models import Item

    # Create tables on startup
    with app.app_context():
        db.create_all()
        print("✔️ Database tables created!")

    # Routes
    @app.route("/health")
    def health():
        return jsonify({"status": "ok"})

    @app.route("/items", methods=["GET"])
    def get_items():
        items = Item.query.all()
        return jsonify([item.to_dict() for item in items])

    @app.route("/items", methods=["POST"])
    def add_item():
        data = request.json
        item = Item(
            name=data["name"],
            category=data.get("category", ""),
            quantity=data.get("quantity", 0),
            description=data.get("description", "")
        )
        db.session.add(item)
        db.session.commit()
        return jsonify(item.to_dict()), 201

    @app.route("/items/<int:item_id>", methods=["DELETE"])
    def delete_item(item_id):
        item = Item.query.get(item_id)
        if item:
            db.session.delete(item)
            db.session.commit()
            return jsonify({"message": "Item deleted"})
        return jsonify({"error": "Item not found"}), 404

    return app
app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

