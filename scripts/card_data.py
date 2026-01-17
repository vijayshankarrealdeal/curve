import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate(
    "/Users/vijayshankar/Desktop/curve/scripts/evesdrops-46b4b-firebase-adminsdk-fbsvc-208f9658fd.json"
)

try:
    firebase_admin.get_app()
except ValueError:
    firebase_admin.initialize_app(cred)

db = firestore.client()
print("🔥 Firebase Initialized.")


scratch_cards_data = [
    {
        "image_url": "https://firebasestorage.googleapis.com/v0/b/evesdrops-46b4b.firebasestorage.app/o/874a7481bbe0cab8f51827722dde96ec.jpg?alt=media&token=8c41641a-dd99-43d6-a390-86fb3c233353",
        "title": "The Power of Touch",
        "description": "Physical touch releases oxytocin, the 'love hormone', which strengthens your emotional bond and reduces stress. Take a moment to hold hands or hug for at least 20 seconds today."
    },
    # Add more here if you have them:
    # { "image_url": "...", "title": "...", "description": "..." }
]

# 3. UPLOAD LOGIC
def upload_cards():
    collection_ref = db.collection('daily_scratch_cards')
    
    # Optional: Delete existing to start fresh (Uncomment if needed)
    # delete_collection(collection_ref)

    print(f"🚀 Uploading {len(scratch_cards_data)} scratch cards...")
    
    count = 0
    batch = db.batch()

    for item in scratch_cards_data:
        # Create a new document with Auto-ID
        doc_ref = collection_ref.document()
        
        batch.set(doc_ref, {
            "image_url": item["image_url"],
            "title": item["title"],
            "description": item["description"],
            "active": True,
            "created_at": firestore.SERVER_TIMESTAMP
        })
        count += 1

    batch.commit()
    print(f"✅ Successfully uploaded {count} cards!")

def delete_collection(coll_ref, batch_size=10):
    docs = coll_ref.limit(batch_size).stream()
    deleted = 0
    for doc in docs:
        doc.reference.delete()
        deleted += 1
    if deleted >= batch_size:
        return delete_collection(coll_ref, batch_size)

if __name__ == "__main__":
    upload_cards()