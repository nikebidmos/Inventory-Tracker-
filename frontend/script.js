const API_URL = "https://improved-space-guacamole-x5wq5757vp5whpwpx-5000.app.github.dev/items"; 

const form = document.getElementById("inventoryForm");
const tbody = document.getElementById("inventoryBody");

// Fetch all items
async function fetchItems() {
  try {
    const res = await fetch(API_URL);
    const items = await res.json();
    tbody.innerHTML = "";-

    items.forEach(item => {
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td>${item.name}</td>
        <td>${item.category || ""}</td>
        <td>${item.quantity}</td>
        <td>${item.description || ""}</td>
        <td class="action-buttons">
          <button class="delete-btn" onclick="deleteItem(${item.id})">Delete</button>
        </td>
      `;
      tbody.appendChild(tr);
    });
  } catch (err) {
    console.error("Error fetching items:", err);
  }
}

// Add item
form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const item = {
    name: document.getElementById("itemName").value,
    quantity: parseInt(document.getElementById("quantity").value),
    category: document.getElementById("category").value,
    description: document.getElementById("description").value
  };

  await fetch(API_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(item)
  });

  form.reset();
  fetchItems();
});

// Delete item
async function deleteItem(id) {
  await fetch(`${API_URL}/${id}`, { method: "DELETE" });
  fetchItems();
}

// Load items immediately
fetchItems();
