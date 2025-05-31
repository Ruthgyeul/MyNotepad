document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');

    // 로그인 폼 제출 이벤트
    if (loginForm) {
        loginForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const usernameInput = loginForm.querySelector('input[name="username"]');
            const passwordInput = loginForm.querySelector('input[name="password"]');

            const usernameValue = usernameInput?.value?.trim();
            const passwordValue = passwordInput?.value?.trim();

            if (usernameValue && passwordValue) {
                sessionStorage.setItem('username', usernameValue);
                window.location.href = window.location.href;
            }
        });
    }

    // 로그인 상태일 경우 사용자 정보 표시
    const usernameValue = sessionStorage.getItem('username');
    if (usernameValue) {
        const loginContainer = document.querySelector('.login-container');
        if (loginForm && loginContainer) {
            loginForm.style.display = 'none';

            const userInfo = document.createElement('div');
            userInfo.className = 'user-info';

            const welcomeSpan = document.createElement('span');
            welcomeSpan.textContent = usernameValue;

            const logoutBtn = document.createElement('button');
            logoutBtn.className = 'logout-btn';
            logoutBtn.textContent = 'Logout';
            logoutBtn.onclick = () => {
                sessionStorage.removeItem('username');
                window.location.href = window.location.href;
            };

            userInfo.appendChild(welcomeSpan);
            userInfo.appendChild(logoutBtn);
            loginContainer.replaceChildren(userInfo);
        }
    }

    // 시작 버튼 클릭 시 로그인 여부 확인
    const startBtn = document.getElementById('startBtn');
    if (startBtn) {
        startBtn.addEventListener('click', () => {
            const username = sessionStorage.getItem('username');
            if (username) {
                window.location.href = 'home.jsp';
            } else {
                showModal();
            }
        });
    }

    // 모달이 없으면 생성
    createLoginModal();
});


// 모달 DOM을 동적으로 생성
function createLoginModal() {
    if (document.getElementById('loginModal')) return;

    const modal = document.createElement('div');
    modal.id = 'loginModal';
    modal.className = 'modal';
    modal.style.display = 'none';
    modal.style.position = 'fixed';
    modal.style.top = '0';
    modal.style.left = '0';
    modal.style.width = '100%';
    modal.style.height = '100%';
    modal.style.backgroundColor = 'rgba(0, 0, 0, 0.4)';
    modal.style.justifyContent = 'center';
    modal.style.alignItems = 'center';
    modal.style.zIndex = '9999';

    const modalContent = document.createElement('div');
    modalContent.className = 'modal-content';
    modalContent.textContent = '로그인이 필요합니다.';
    modalContent.style.backgroundColor = '#fff';
    modalContent.style.padding = '20px 30px';
    modalContent.style.borderRadius = '10px';
    modalContent.style.boxShadow = '0 4px 10px rgba(0, 0, 0, 0.2)';
    modalContent.style.fontSize = '1.2rem';

    modal.appendChild(modalContent);
    document.body.appendChild(modal);
}

// 모달 보여주고 1초 후 자동 닫기
function showModal() {
    const modal = document.getElementById('loginModal');
    if (modal) {
        modal.style.display = 'flex';
        setTimeout(() => {
            modal.style.display = 'none';
        }, 1000);
    }
}