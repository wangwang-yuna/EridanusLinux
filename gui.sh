#!/bin/bash

# 定义选项
OPTIONS=( 
    "运行 napcat" 
    "启动Eridanus"
    "退出"
)

# 定义 napcat 和 Eridanus 的 screen 会话名称
NAPCAT_SESSION="napcat"
ERIDANUS_SESSION="eridanus"

# 检查 napcat 是否正在运行
check_napcat_running() {
    if screen -list | grep -q "$NAPCAT_SESSION"; then
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
    
    # 检查用户选择的有效性
    case $? in
        1)  # 用户按了 ESC 或 Cancel
            dialog --msgbox "退出脚本！" 5 20
            exit ;;
    esac

    case $CHOICE in
        "运行 napcat")
            # 执行命令
            screen -dmS "$NAPCAT_SESSION" bash -c "xvfb-run -a qq --no-sandbox"
            sleep 2  # 等待 2 秒后检查启动状态
            # 检查 napcat 是否启动成功
            if check_napcat_running; then
                dialog --msgbox "已成功启动 napcat！" 5 30
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
                screen -dmS "$ERIDANUS_SESSION" bash -c "python3 Eridanus/main.py"
                dialog --msgbox "已成功启动 Eridanus！" 5 30
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
