#!/bin/bash

# 1. รับชื่อผู้ใช้จากผู้ใช้หรืออาร์กิวเมนต์
read -p "USERNEW: " username

# 2. สร้างผู้ใช้ด้วยคำสั่ง useradd
sudo useradd $username

# 3. รับรหัสผ่านจากผู้ใช้
read -s -p "PASSNEW: " password
echo

# 4. ใช้คำสั่ง passwd เพื่อตั้งรหัสผ่าน
echo -e "$password\n$password" | sudo passwd $username

# 5. ตรวจสอบว่าผู้ใช้ถูกสร้างและรหัสผ่านถูกตั้ง
if [ $? -eq 0 ]; then
    echo "USER: $username DONE WORK!!"
else
    echo "DAMNN!!!"
fi
