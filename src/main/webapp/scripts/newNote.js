function newNoteAutoInfo() {
    document.getElementById("noteId").textContent = "No. " + Math.floor(Math.random() * 1000);
    document.getElementById("createDate").textContent = new Date().toLocaleString();
}