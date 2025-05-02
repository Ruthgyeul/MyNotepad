function searchNotes() {
    const searchValue = document.getElementById("searchInput").value.toLowerCase();
    const categoryValue = document.getElementById("categoryFilter").value;
    const rows = document.querySelectorAll("tbody tr");

    rows.forEach(row => {
        const category = row.cells[2].innerText;
        const title = row.cells[3].innerText.toLowerCase();

        const categoryMatch = categoryValue === "all" || category === categoryValue;
        const searchMatch = title.includes(searchValue);

        row.style.display = categoryMatch && searchMatch ? "" : "none";
    });
}