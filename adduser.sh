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

    # 6. ถามผู้ใช้ว่าต้องการกำหนดวันหมดอายุหรือไม่
    read -p "ต้องการกำหนดวันหมดอายุ (ในวัน) ให้กับบัญชีผู้ใช้นี้หรือไม่ (y/n)? " choice

    if [ "$choice" == "y" ]; then
        # 7. รับจำนวนวันที่ต้องการให้บัญชีผู้ใช้หมดอายุ
        read -p "ระบุจำนวนวันที่ต้องการ (ในวัน): " days
        # 8. ใช้คำสั่ง chage เพื่อกำหนดวันหมดอายุ
        sudo chage -M $days $username
        echo "วันหมดอายุถูกกำหนดสำหรับผู้ใช้: $username"
    else
        echo "ไม่ได้กำหนดวันหมดอายุสำหรับผู้ใช้: $username"
    fi

    # 9. แสดงข้อมูลผู้ใช้ในหน้าคอมแมนด์ไลน์
    echo "User Information:"
    echo "Username: $username"
    echo "Password: $password"
    echo "Expiration (days): $days day"
else
    echo "DAMNN!!!"
fi
