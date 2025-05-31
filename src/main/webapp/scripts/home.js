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

function filterNotes() {
    const categoryId = document.getElementById('categoryFilter').value;
    const rows = document.querySelectorAll('tbody tr');
    
    rows.forEach(row => {
        if(categoryId === 'all') {
            row.style.display = '';
        } else {
            const categoryCell = row.cells[2];
            const categoryName = categoryCell.textContent;
            const option = document.querySelector(`#categoryFilter option[value="${categoryId}"]`);
            row.style.display = categoryName === option.textContent ? '' : 'none';
        }
    });
}

function searchNotes(event) {
    event.preventDefault();
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('tbody tr');
    
    rows.forEach(row => {
        const title = row.cells[3].textContent.toLowerCase();
        row.style.display = title.includes(searchTerm) ? '' : 'none';
    });
    
    return false;
}