#!/bin/bash

# 定义选项
OPTIONS=( 
    "运行 napcat" 
    "启动Eridanus"
    "退出"
)

# 检查 napcat 是否正在运行
check_napcat_running() {
    if screen -list | grep -q "napcat"; then
        return 0  # napcat 正在运行
    else
        return 1  # napcat 未运行
    fi
}

# 弹窗显示内容
show_url() {
    dialog --msgbox "http://0.0.0.0:6099/webui?token=3eityfay1fv" 10 50
}

# 创建菜单
while true; do
    CHOICE=$(dialog --title "选择一个选项" --menu "请使用上下箭头选择一个选项：" 15 50 3 "${OPTIONS[@]}" 3>&1 1>&2 2>&3)
    
    case $CHOICE in
        "运行 napcat")
            # 执行命令
            screen -dmS napcat bash -c "xvfb-run -a qq --no-sandbox"
            # 检查 napcat 是否启动成功
            if check_napcat_running; then
                dialog --msgbox "已启动 napcat!" 5 30
                # 弹窗显示 URL
                show_url
            else
                dialog --msgbox "napcat 启动失败，请检查！" 5 40
            fi
            ;;
        "启动Eridanus")
            # 检查 napcat 是否正在运行
            if check_napcat_running; then
                # 执行命令
                screen -dmS eridanus bash -c "python3 main.py"
                dialog --msgbox "已启动 Eridanus!" 5 30
            else
                dialog --msgbox "napcat 未运行，请先运行 napcat！" 5 40
            fi
            ;;
        "退出")
            break
            ;;
        *)
            dialog --msgbox "无效的选择，请重试。" 5 30
            ;;
    esac
done

# 清理
clear
