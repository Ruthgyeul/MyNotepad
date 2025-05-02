/*==== Check Login Token ====*/
function isLoggedIn() {
    const token = localStorage.getItem('token');
    if (token) {
        axios.post('http://localhost/api/v1/loginCheck', token)
        .then(function (response) {
            if (response.data.status == 200) {
                // token confirmed.
                alert(response.data.message);
                localStorage.setItem('token', response.data.token);
                window.location.href = "home.html";
            } else {
                // token expired -> need login
                alert(response.data.message);
            }
        })
        .catch(function (error) {
            console.log(error);
        });
    } else {
        // no token exists.
        return false;
    }
}

/*==== Login ====*/
function login() {
    const username = document.getElementById('userId').value;
    const password = document.getElementById('pwd').value;
    const data = {
        username: username,
        password: password
    }
    console.log("called");
    axios.post('http://localhost/api/v1/login', data)
        .then(function (response) {
            if (response.data.status == 200) {
                alert(response.data.message);
                localStorage.setItem('token', response.data.token);
                window.location.href = "home.html";
            } else {
                alert(response.data.message);
            }
        })
        .catch(function (error) {
            console.log(error);
        });
}