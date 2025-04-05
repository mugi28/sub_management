from flask import Blueprint, render_template, request, redirect, url_for, flash

auth_bp = Blueprint('auth', __name__, url_prefix='/auth')

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user_id = request.form['user_id']
        password = request.form['password']
        print(f"로그인 시도 (블루프린트) - 아이디: {user_id}, 비밀번호: {password}")
        return redirect(url_for('main.dashboard')) # 메인 블루프린트의 대시보드로 리다이렉트 (추후 수정)
    return render_template('auth/login.html')

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        user_id = request.form['user_id']
        name = request.form['name']
        email = request.form['email']
        phone_number = request.form['phone_number']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        if password != confirm_password:
            flash('비밀번호가 일치하지 않습니다.', 'error')
            return render_template('auth/register.html')

        print("회원가입 정보 (블루프린트):")
        print(f"  아이디: {user_id}")
        print(f"  이름: {name}")
        print(f"  이메일: {email}")
        print(f"  전화번호: {phone_number}")
        print(f"  비밀번호: {password}")
        # 실제 데이터베이스 저장 로직은 추후 구현
        return redirect(url_for('auth.login'))
    return render_template('auth/register.html')